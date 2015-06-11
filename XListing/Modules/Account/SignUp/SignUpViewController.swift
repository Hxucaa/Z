//
//  SignUpViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

public final class SignUpViewController : UIViewController {
    private var viewmodel: SignUpViewModel!
    
    @IBOutlet weak var signupButton: UIButton!
    
    private var editProfileViewNibName: String!
    
    private var editProfileView: EditProfileView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signupButton.addTarget(self, action: "signupButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
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
}

extension SignUpViewController : EditProfileViewDelegate {
    
    public func presentUIImagePickerController(imagePicker: UIImagePickerController) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    public func dismissSignUpView (handler: CompletionHandler?) {
        self.dismissViewControllerAnimated(true, completion: handler)
        
    }
}