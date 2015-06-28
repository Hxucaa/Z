//
//  SignUpViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SVProgressHUD

public final class SignUpViewController : XUIViewController {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var backgroundLabel: UILabel!
    
    // MARK: Actions
    private var signupButtonAction: CocoaAction!
    
    // MARK: Private variables
    private var editProfileViewNibName: String!
    private var editProfileView: EditProfileView!
    private var viewmodel: SignUpViewModel!
    private var editProfileViewmodel: EditProfileViewModel!
    
    // MARK: Delegate
    public weak var delegate: SignUpViewDelegate!
    
    // MARK: Setup Code
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeBackgroundCornersRound()
        setUpUsername()
        setUpPassword()
        setUpBackButton()
        setUpSignupButton()
    }
    
    private func setUpBackButton () {
        backButton.addTarget(self, action: "returnToLandingView", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    internal func makeBackgroundCornersRound () {
        self.backgroundLabel.layer.masksToBounds = true;
        self.backgroundLabel.layer.cornerRadius = 8;
    }
    
    public func returnToLandingView () {
        self.delegate.returnToLandingViewFromSignUp()
    }
    
    private func setUpSignupButton () {
        signupButton.rac_enabled <~ viewmodel.allInputsValid.producer
        
        let signup = Action<Void, Bool, NSError> { [unowned self] in
            // display HUD to indicate work in progress
            let signUpAndHUD = HUD.show()
                // map error to the same type as other signal
                |> mapError { _ in NSError() }
                // sign up
                |> then(self.viewmodel.signUp)
                // dismiss HUD based on the result of sign up signal
                |> HUD.onDismissWithStatusMessage(errorHandler: { error -> String in
                    AccountLogError(error.description)
                    return error.customErrorDescription
                })
            
            let HUDDisappear = HUD.didDissappearNotification() |> mapError { _ in NSError() }
            
            // combine the latest signal of sign up and hud dissappear notification
            // once sign up is done properly and HUD is disappeared, proceed to next step
            return combineLatest(signUpAndHUD, HUDDisappear)
                |> map { success, notificationMessage -> Bool in
                    self.goToEditProfileView()
                    return success
            }
        }
        
        // Bridging actions to Objective-C
        signupButtonAction = CocoaAction(signup, input: ())
        
        // Link UIControl event to actions
        signupButton.addTarget(signupButtonAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func goToEditProfileView () {
        
        // call the signup action in the viewmodel, and if that returns true then proceed
        
        editProfileView = NSBundle.mainBundle().loadNibNamed("EditProfileView", owner: self, options: nil).first as? EditProfileView
        editProfileView.delegate = self
        editProfileView.bindToViewModel(editProfileViewmodel)
    
    // Put view to display
        self.view = editProfileView
    }
    
    public func bindToViewModel(viewmodel: SignUpViewModel, editProfileViewmodel: EditProfileViewModel) {
        self.viewmodel = viewmodel
        self.editProfileViewmodel = editProfileViewmodel
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

extension SignUpViewController : EditProfileViewDelegate {
    
    public func presentUIImagePickerController(imagePicker: UIImagePickerController) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    public func dismissSignUpView (handler: CompletionHandler?) {
        self.dismissViewControllerAnimated(true, completion: handler)
        
    }
}

extension SignUpViewController : UITextFieldDelegate {
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
