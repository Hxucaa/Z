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
    
    // MARK: Actions
    private var signupButtonAction: CocoaAction!
    
    // MARK: Private variables
    private var viewmodel: SignUpViewModel!
    
    // MARK: Delegate
    public weak var delegate: SignUpViewDelegate!
    
    // MARK: Setup Code
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setUpBackButton () {
        let goBackAction = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { sink, disposable in
                self.delegate.returnToLandingViewFromSignUp()
                sendCompleted(sink)
            }
        }
        
        backButton.addTarget(goBackAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setUpSignupButton () {
        signupButton.rac_enabled <~ viewmodel.allInputsValid.producer
        
        let signup = Action<Void, Bool, NSError> { [unowned self] in
            // display HUD to indicate work in progress
            let signUpAndHUD = HUD.show()
                // map error to the same type as other signal
                |> promoteErrors(NSError)
                // sign up
                |> then(self.viewmodel.signUp)
                // dismiss HUD based on the result of sign up signal
                |> HUD.onDismissWithStatusMessage(errorHandler: { error -> String in
                    AccountLogError(error.description)
                    return error.customErrorDescription
                })
            
            let HUDDisappear = HUD.didDissappearNotification() |> promoteErrors(NSError)
            
            // combine the latest signal of sign up and hud dissappear notification
            // once sign up is done properly and HUD is disappeared, proceed to next step
            return combineLatest(signUpAndHUD, HUDDisappear)
                |> map { [unowned self] success, notificationMessage -> Bool in
                    self.delegate.gotoEditInfoView()
                    return success
            }
        }
        
        // Bridging actions to Objective-C
        signupButtonAction = CocoaAction(signup, input: ())
        
        // Link UIControl event to actions
        signupButton.addTarget(signupButtonAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func bindToViewModel(viewmodel: SignUpViewModel) {
        self.viewmodel = viewmodel
        
        setUpUsername()
        setUpPassword()
        setUpBackButton()
        setUpSignupButton()
    }
    
    private func setUpUsername() {
        usernameField.delegate = self
        viewmodel.username <~ usernameField.rac_text
    }
    
    private func setUpPassword() {
        passwordField.delegate = self
        viewmodel.password <~ passwordField.rac_text
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
            AccountLogError("Unreachable code block")
        }
        return false
    }
}
