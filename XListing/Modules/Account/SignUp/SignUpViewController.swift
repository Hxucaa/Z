//
//  SignUpViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

public final class SignUpViewController : XUIViewController {
    private var viewmodel: SignUpViewModel!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private var editProfileViewNibName: String!
    
    private var editProfileView: EditProfileView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signupButton.addTarget(self, action: "signupButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.addTarget(self, action: "goBackToLanding", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func signupButtonPressed () {
        editProfileView = NSBundle.mainBundle().loadNibNamed("EditProfileView", owner: self, options: nil).first as? EditProfileView
        editProfileView.delegate = self
        //editProfileView.bindToViewModel(viewmodel.editProfileViewModel)
    
    // Put view to display
        self.view = editProfileView
    }
    
    public func bindToViewModel(viewmodel: SignUpViewModel) {
        self.viewmodel = viewmodel
    }
    
    public func goBackToLanding () {
        self.dismissViewControllerAnimated(true, completion: nil)
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