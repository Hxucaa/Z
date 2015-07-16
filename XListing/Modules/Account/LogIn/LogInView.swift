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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - Delegate
    public weak var delegate: LoginViewDelegate?
    
    // MARK: - Private variables
    private let viewmodel = MutableProperty<LogInViewModel?>(nil)
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBackButton()
        
        viewmodel.producer
            |> ignoreNil
            |> start(next: { [unowned self] viewmodel in
                self.setupUsername(viewmodel)
                self.setupPassword(viewmodel)
                self.setupLoginButton(viewmodel)
            })
    }
    
    private func setupUsername(viewmodel: LogInViewModel) {
        usernameField.delegate = self
        viewmodel.username <~ usernameField.rac_text
    }
    
    private func setupPassword(viewmodel: LogInViewModel) {
        passwordField.delegate = self
        viewmodel.password <~ passwordField.rac_text
    }
    
    private func setupLoginButton(viewmodel: LogInViewModel) {
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 8
        loginButton.rac_enabled <~ viewmodel.allInputsValid.producer
        
        let login = Action<UIButton, User, NSError> { [unowned self] button in
            // display HUD to indicate work in progress
            let logInAndHUD = HUD.show()
                // map error to the same type as other signal
                |> promoteErrors(NSError)
                // log in
                |> then(viewmodel.logIn)
                // dismiss HUD based on the result of log in signal
                |> HUD.onDismissWithStatusMessage(errorHandler: { error -> String in
                    AccountLogError(error.description)
                    return error.customErrorDescription
                })
            
            let HUDDisappear = HUD.didDissappearNotification() |> promoteErrors(NSError)
            
            // combine the latest signal of log in and hud dissappear notification
            // once log in is done properly and HUD is disappeared, proceed to next step
            return combineLatest(logInAndHUD, HUDDisappear)
                |> map { user, notificationMessage -> User in
                    self.delegate?.loginViewFinished()
                    return user
            }
        }
        
        // Link UIControl event to actions
        loginButton.addTarget(login.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupBackButton () {
        
        let backAction = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { sink, disposable in
                // go back to previous view
                self.delegate?.goBackToPreviousView()
                sendCompleted(sink)
            }
        }
        
        backButton.addTarget(backAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func bindToViewModel(viewmodel: LogInViewModel) {
        self.viewmodel.put(viewmodel)
        
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
            endEditing(true)
            // start an empty SignalProducer
            SignalProducer<Void, NoError>.empty
                // delay the signal due to the animation of retracting keyboard
                // this cannot be executed on main thread, otherwise UI will be blocked
                |> delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                // return the signal to main/ui thread in order to run UI related code
                |> observeOn(UIScheduler())
                |> start(completed: { [unowned self] in
                    self.loginButton.sendActionsForControlEvents(.TouchUpInside)
                })
        default:
            break
        }
        return false
    }
}