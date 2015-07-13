//
//  LogInViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public final class LogInViewController: XUIViewController{
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var backgroundLabel: UILabel!
    
    // MARK: Actions
    private var loginButtonAction: CocoaAction!
    private var dismissViewButtonAction: CocoaAction!
    
    // MARK: - Delegate
    public weak var delegate: LoginViewDelegate!
    
    // MARK: - Private variables
    private var viewmodel: LogInViewModel!
    
    // MARK: Setup
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpBackgroundLabel()
        setUpUsername()
        setUpPassword()
        setUpLoginButton()
        setUpBackButton()
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        loginButtonAction = nil
        dismissViewButtonAction = nil
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpBackgroundLabel () {
        self.backgroundLabel.layer.masksToBounds = true;
        self.backgroundLabel.layer.cornerRadius = 8;
    }
    
    private func setUpUsername() {
        usernameField.delegate = self
        viewmodel.username <~ usernameField.rac_text
    }
    
    private func setUpPassword() {
        passwordField.delegate = self
        viewmodel.password <~ passwordField.rac_text
    }
    
    private func setUpLoginButton () {
        loginButton.rac_enabled <~ viewmodel.allInputsValid.producer
        
        let login = Action<Void, User, NSError> { [unowned self] in
            // display HUD to indicate work in progress
            let logInAndHUD = HUD.show()
                // map error to the same type as other signal
                |> mapError { _ in NSError() }
                // log in
                |> then(self.viewmodel.logIn)
                // dismiss HUD based on the result of log in signal
                |> HUD.onDismissWithStatusMessage(errorHandler: { error -> String in
                    AccountLogError(error.description)
                    return error.customErrorDescription
                })
            
            let HUDDisappear = HUD.didDissappearNotification() |> mapError { _ in NSError() }
            
            // combine the latest signal of log in and hud dissappear notification
            // once log in is done properly and HUD is disappeared, proceed to next step
            return combineLatest(logInAndHUD, HUDDisappear)
                |> map { user, notificationMessage -> User in
                    self.viewmodel.dismissAccountView()
                    return user
            }
        }
        
        // Bridging actions to Objective-C
        loginButtonAction = CocoaAction(login, input: ())
        
        // Link UIControl event to actions
        loginButton.addTarget(loginButtonAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setUpBackButton () {
        backButton.addTarget(self, action: "returnToLandingView", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func returnToLandingView () {
        self.delegate.returnToLandingViewFromLogin()
    }
    
    public func bindToViewModel(viewmodel: LogInViewModel) {
        self.viewmodel = viewmodel
        
    }
    
}

extension LogInViewController : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    :param: textField The text field whose return button was pressed.
    
    :returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

