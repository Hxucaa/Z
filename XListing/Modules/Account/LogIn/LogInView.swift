//
//  LogInView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

public final class LogInView : UIView {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    // MARK: - Proxies
    /// Go back to previous page.
    public var goBackProxy: SimpleProxy {
        return _goBackProxy
    }
    private let (_goBackProxy, _goBackSink) = SimpleProxy.proxy()
    
    /// Log In view is finished.
    public var finishLoginProxy: SimpleProxy {
        return _finishLoginProxy
    }
    private let (_finishLoginProxy, _finishLoginSink) = SimpleProxy.proxy()
    
    // MARK: - Properties
    private var viewmodel: LogInViewModel!
    
    // MARK: Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUsernameField()
        setupPasswordField()
        setupLoginButton()
        setupBackButton()
    }
    
    private func setupUsernameField() {
        usernameField.delegate = self
        // focus on the username field as soon as the view is displayed
    }
    
    private func setupPasswordField() {
        passwordField.delegate = self
    }
    
    private func setupLoginButton() {
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 8
        
        let login = Action<UIButton, Void, NSError> { [weak self] button in
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
                        // log in
                        |> then(this.viewmodel.logIn)
                        // dismiss HUD based on the result of log in signal
                        |> HUD.dismissWithStatusMessage(errorHandler: { error -> String in
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
                                sendNext(this._finishLoginSink, ())
                                sendCompleted(this._finishLoginSink)
                            }
                            
                            // completes the action
                            sendNext(sink, ())
                            sendCompleted(sink)
                            
                        })
                    
                    // Add the signals to CompositeDisposable for automatic memory management
                    disposable.addDisposable {
                        AccountLogVerbose("Log in action is disposed.")
                    }
                    
                    // retract keyboard
                    self?.endEditing(true)
                }
            }
        }
        
        loginButton.addTarget(login.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupBackButton () {
        
        let backAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                self?.endEditing(true)
                
                sendCompleted(sink)
                
                // go back to previous view
                if let this = self {
                    // transition out of this page
                    sendNext(this._goBackSink, ())
                }
            }
        }
        
        backButton.addTarget(backAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    deinit {
        AccountLogVerbose("Log In View deinitializes.")
    }
    
    // MARK: Bindings    
    
    /**
    Bind viewmodel to view.
    
    :param: viewmodel The viewmodel
    */
    public func bindToViewModel(viewmodel: LogInViewModel) {
        self.viewmodel = viewmodel
        
        self.viewmodel.username <~ usernameField.rac_text
        self.viewmodel.password <~ passwordField.rac_text
        loginButton.rac_enabled <~ self.viewmodel.allInputsValid.producer
    }
    
    // MARK: Others
    
    /**
    Notify receiver that it is about to be the first reponsider.
    */
    public func startFirstResponder() {
        usernameField.becomeFirstResponder()
    }
}

extension LogInView : UITextFieldDelegate {
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
            
            loginButton.sendActionsForControlEvents(.TouchUpInside)
        default:
            break
        }
        return false
    }
}