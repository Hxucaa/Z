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
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: Properties
    private var viewmodel: SignUpViewModel!
    
    // MARK: Delegate
    public weak var delegate: SignUpViewDelegate?
    
    // MARK: Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBackButton()
        setupUsername()
        setupPassword()
        setupSignupButton()
    }
    
    private func setupBackButton () {
        let goBackAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { [weak self] sink, disposable in
                self?.delegate?.returnToLandingViewFromSignUp()
                sendCompleted(sink)
            }
        }
        
        backButton.addTarget(goBackAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupSignupButton () {
        
        let signup = Action<UIButton, Bool, NSError> { button in
            return SignalProducer { sink, disposable in
                // display HUD to indicate work in progress
                let hudAndSignUp = HUD.show()
                    // map error to the same type as other signal
                    |> promoteErrors(NSError)
                    // sign up
                    |> then(self.viewmodel.signUp)
                    // dismiss HUD based on the result of sign up signal
                    |> HUD.dismissWithStatusMessage(errorHandler: { [weak self] error -> String in
                        AccountLogError(error.description)
                        return error.customErrorDescription
                    })
                    |> start(
                        error: { error in
                            sendError(sink, error)
                        },
                        interrupted: { _ in
                            sendInterrupted(sink)
                        }
                    )
                
                // Subscribe to disappear notification
                let didDisappearDisposable = HUD.didDissappearNotification()
                    |> on(next: { _ in AccountLogVerbose("HUD disappeared.") })
                    |> start(next: { [weak self] status in
                        // transition out of this page
                        self?.delegate?.gotoEditInfoView()
                        
                        // completes the action
                        sendNext(sink, true)
                        sendCompleted(sink)
                    })
                
                // Subscribe to touch down inside event
                let touchDownInsideDisposable = HUD.didTouchDownInsideNotification()
                    |> on(next: { _ in AccountLogVerbose("HUD touch down inside.") })
                    |> start(
                        next: { _ in
                            // dismiss HUD
                            HUD.dismiss()
                            
                            // interrupts the action
                            sendInterrupted(sink)
                        }
                    )
                
                // Add the signals to CompositeDisposable for automatic memory management
                disposable.addDisposable(didDisappearDisposable)
                disposable.addDisposable(touchDownInsideDisposable)
                disposable.addDisposable(hudAndSignUp)
            }
        }
        
        // Link UIControl event to actions
        signupButton.addTarget(signup.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupUsername() {
        usernameField.delegate = self
    }
    
    private func setupPassword() {
        passwordField.delegate = self
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
            endEditing(true)
            // start an empty SignalProducer
            SignalProducer<Void, NoError>.empty
                // delay the signal due to the animation of retracting keyboard
                // this cannot be executed on main thread, otherwise UI will be blocked
                |> delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                // return the signal to main/ui thread in order to run UI related code
                |> observeOn(UIScheduler())
                |> start(completed: { [weak self] in
                    self?.signupButton.sendActionsForControlEvents(.TouchUpInside)
                })
        default:
            break
        }
        return false
    }
}
