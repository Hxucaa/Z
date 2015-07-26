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

public final class SignUpView : UIView {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Proxies
    
    /// Go back to previous page.
    public var goBackProxy: SimpleProxy.Producer {
        return _goBackProxy
    }
    private let (_goBackProxy, _goBackSink) = SimpleProxy.pipe()
    
    /// Sign Up view is finished.
    public var finishSignUpProxy: SimpleProxy.Producer {
        return _finishSignUpProxy
    }
    private let (_finishSignUpProxy, _finishSignUpSink) = SimpleProxy.pipe()
    
    // MARK: Properties
    private var viewmodel: SignUpViewModel!
    
    // MARK: Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUsernameField()
        setupPasswordField()
        setupBackButton()
        setupSignupButton()
    }
    
    private func setupUsernameField() {
        usernameField.delegate = self
        // focus on the username field as soon as the view is displayed
        usernameField.becomeFirstResponder()
    }
    
    private func setupPasswordField() {
        passwordField.delegate = self
    }
    
    private func setupBackButton () {
        let goBackAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { [weak self] sink, disposable in
                self?.endEditing(true)
                
                sendCompleted(sink)
                
                if let this = self {
                    sendNext(this._goBackSink, ())
                    sendCompleted(this._goBackSink)
                }
            }
        }
        
        backButton.addTarget(goBackAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupSignupButton () {
        signupButton.layer.masksToBounds = true
        signupButton.layer.cornerRadius = 8
        
        let signup = Action<UIButton, Void, NSError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    // display HUD to indicate work in progress
                    let hudAndSignUp = SignalProducer<Void, NoError>.empty
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
                    let touchDownInside = HUD.didTouchDownInsideNotification()
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
                    let didDisappear = HUD.didDissappearNotification()
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
                    disposable.addDisposable(didDisappear)
                    disposable.addDisposable(touchDownInside)
                    disposable.addDisposable(hudAndSignUp)
                    disposable.addDisposable({ () -> () in
                        AccountLogVerbose("Sign up action is completed.")
                    })
                    
                    // retract keyboard
                    self?.endEditing(true)
                }
            }
        }
        
        // Link UIControl event to actions
        signupButton.addTarget(signup.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: SignUpViewModel) {
        self.viewmodel = viewmodel
        
        // bind signals
        viewmodel.username <~ usernameField.rac_text
        viewmodel.password <~ passwordField.rac_text
        signupButton.rac_enabled <~ viewmodel.allInputsValid
    }
}

extension SignUpView : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    :param: textField The text field whose return button was pressed.
    
    :returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case usernameField:
            passwordField.becomeFirstResponder()
        case passwordField:
            passwordField.resignFirstResponder()
            
            signupButton.sendActionsForControlEvents(.TouchUpInside)
        default:
            break
        }
        return false
    }
}
