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
    private var viewmodel: SignUpViewModel!
    private var editProfileViewmodel: EditProfileViewModel!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    private var signupButtonAction: CocoaAction!
    
    private var editProfileViewNibName: String!
    private var editProfileView: EditProfileView!
    
    private var HUDdisposable: Disposable!
    
    internal var containerVC : ContainerViewController!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupHUD()
        setUpBackButton()
        setUpSignupButton()
    }
    
    /**
    Setup HUD
    */
    private func setupHUD() {
        HUDdisposable = HUD.didDissappearNotification(
            interrupted: {
            },
            error: {
            },
            completed: {
                self.goToEditProfileView()
                self.HUDdisposable.dispose()
            }
        )
    }
    
    public func setUpBackButton () {
        backButton.addTarget(self, action: "returnToLanding", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func setUpSignupButton () {
        
        let signup = Action<Void, Bool, NSError> {
            return HUD.show()
                |> mapError { _ in NSError() }
                |> flatMap(FlattenStrategy.Merge) { _ in self.viewmodel.signUp }
                |> HUD.onDismiss()
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
    
    public func returnToLanding () {
        self.containerVC.switchToLanding()
    }
    
    public func setUpUsername() {
        usernameField.delegate = self
        viewmodel.username <~ usernameField.rac_text
    }
    
    public func setUpPassword() {
        passwordField.delegate = self
        viewmodel.password <~ passwordField.rac_text
    }
    
//    public func setUpConfirmPassword() {
//        confirmPasswordField.delegate = self
//        viewmodel.confirmPassword <~ confirmPasswordField.rac_text
//    }
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
