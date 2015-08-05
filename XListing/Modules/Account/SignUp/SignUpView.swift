//
//  SignUpView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography

private let UsernameAndPasswordFieldsNibName = "UsernameAndPasswordFields"

public final class SignUpView : UIView {
    
    // MARK: - UI Controls
    
    // MARK: Top Stack
    @IBOutlet private weak var topStack: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var primaryLabel: UILabel!
    @IBOutlet private weak var secondaryLabel: UILabel!
    
    // MARK: Mid Stack
    @IBOutlet private weak var midStack: UIView!
    private var usernameAndPasswordFields: UIView!
    @IBOutlet private weak var usernameField: UITextField?
    @IBOutlet private weak var passwordField: UITextField?
    
    // MARK: Bottom Stack
    @IBOutlet private weak var bottomStack: UIView!
    @IBOutlet private weak var confirmButton: UIButton!
    
    // MARK: - Proxies
    
    /// Go back to previous page.
    public var goBackProxy: SimpleProxy {
        return _goBackProxy
    }
    private let (_goBackProxy, _goBackSink) = SimpleProxy.proxy()
    
    /// Sign Up view is finished.
    public var finishSignUpProxy: SimpleProxy {
        return _finishSignUpProxy
    }
    private let (_finishSignUpProxy, _finishSignUpSink) = SimpleProxy.proxy()
    
    // MARK: - Properties
    private var viewmodel: SignUpViewModel!
    
    // MARK: - Setups
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        usernameAndPasswordFields = UINib(nibName: UsernameAndPasswordFieldsNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
    }
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        
        midStack.addSubview(usernameAndPasswordFields)
        usernameAndPasswordFields.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let centerX = NSLayoutConstraint(item: usernameAndPasswordFields,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: midStack,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: 0.0)
        centerX.identifier = "usernameAndPasswordFields to midStack centerX"
        
        let topSpacing = NSLayoutConstraint(item: usernameAndPasswordFields,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: midStack,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: (midStack.frame.height - usernameAndPasswordFields.frame.height) / 2)
        topSpacing.identifier = "usernameAndPasswordFields to midStack topSpacing"
        
        addConstraints(
            [
                centerX,
                topSpacing
            ]
        )
        
//        layout(usernameAndPasswordFields, midStack) { fields, midStack in
//            align(centerX: fields, midStack)
//            fields.top == midStack.top + (self.midStack.frame.height - self.usernameAndPasswordFields.frame.height) / 2
//        }
        
        
        setupUsernameField()
        setupPasswordField()
        setupBackButton()
        setupSignupButton()
    }
    
    private func setupUsernameField() {
        usernameField?.delegate = self
    }
    
    private func setupPasswordField() {
        passwordField?.delegate = self
    }
    
    private func setupBackButton () {
        let goBackAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { [weak self] sink, disposable in
                self?.endEditing(true)
                
                sendCompleted(sink)
                
                if let this = self {
                    sendNext(this._goBackSink, ())
                }
            }
        }
        
        backButton.addTarget(goBackAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupSignupButton () {
        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 8
        
        let signup = Action<UIButton, Void, NSError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    // display HUD to indicate work in progress
                    disposable += SignalProducer<Void, NoError>.empty
                        // delay the signal due to the animation of retracting keyboard
                        // this cannot be executed on main thread, otherwise UI will be blocked
                        |> delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                        // return the signal to main/ui thread in order to run UI related code
                        |> observeOn(UIScheduler())
                        |> then(HUD.show())
                        // map error to the same type as other signal
                        |> promoteErrors(NSError)
                        // sign up
                        |> then(this.viewmodel.signUp)
                        // dismiss HUD based on the result of sign up signal
                        |> HUD.dismissWithStatusMessage(errorHandler: { [weak self] error -> String in
                            AccountLogError(error.description)
                            return error.customErrorDescription
                        })
                        // does not `sendCompleted` because completion is handled when HUD is disappeared
                        |> start(
                            error: { error in
                                sendError(sink, error)
                            },
                            interrupted: { _ in
                                sendInterrupted(sink)
                            }
                    )
                    
                    // Subscribe to touch down inside event
                    disposable += HUD.didTouchDownInsideNotification()
                        |> on(next: { _ in AccountLogVerbose("HUD touch down inside.") })
                        |> start(
                            next: { _ in
                                // dismiss HUD
                                HUD.dismiss()
                                
                                // interrupts the action
//                                sendInterrupted(sink)
                            }
                    )
                    
                    // Subscribe to disappear notification
                    disposable += HUD.didDissappearNotification()
                        |> on(next: { _ in AccountLogVerbose("HUD disappeared.") })
                        |> start(next: { [weak self] status in
                            if status == HUD.DisappearStatus.Normal {
                                // transition out of this page
                                sendNext(this._finishSignUpSink, ())
                                sendCompleted(this._finishSignUpSink)
                            }
                            
                            // completes the action
                            sendNext(sink, ())
                            sendCompleted(sink)
                            
                        })
                    
                    // Add the signals to CompositeDisposable for automatic memory management
                    disposable.addDisposable {
                        AccountLogVerbose("Sign up action is disposed.")
                    }
                    
                    // retract keyboard
                    self?.endEditing(true)
                }
            }
        }
        
        // Link UIControl event to actions
        confirmButton.addTarget(signup.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    deinit {
        AccountLogVerbose("Sign Up View deinitializes.")
    }
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: SignUpViewModel) {
        self.viewmodel = viewmodel
        
        // bind signals
        if let usernameField = usernameField {
            viewmodel.username <~ usernameField.rac_text
        }
        if let passwordField = passwordField {
            viewmodel.password <~ passwordField.rac_text
        }
        
        // TODO: implement different validation for different input fields.
//        confirmButton.rac_enabled <~ viewmodel.allInputsValid
    }
    
    // MARK: Others
    /**
    Notify receiver that it is about to be the first reponsider.
    */
    public func startFirstResponder() {
        usernameField?.becomeFirstResponder()
    }
}

extension SignUpView : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    :param: textField The text field whose return button was pressed.
    
    :returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let usernameField = usernameField where usernameField == textField {
            passwordField?.becomeFirstResponder()
        }
        else if let passwordField = passwordField where passwordField == textField {
            passwordField.resignFirstResponder()
            confirmButton.sendActionsForControlEvents(.TouchUpInside)
        }
        return false
    }
}
