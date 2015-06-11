//
//  EditProfileViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit
import Foundation

private let EditProfileViewNibName = "EditProfileView"

public final class EditProfileViewController : UIViewController {
    private var viewmodel: EditProfileViewModel!
    private var editProfileView: EditProfileView!
    
    public override func loadView() {
        super.loadView()
        
        // Load nib as viewbut
         editProfileView = NSBundle.mainBundle().loadNibNamed(EditProfileViewNibName, owner: self, options: nil).first as? EditProfileView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displaySignUpView()
    }
    
    private func displaySignUpView() {
        editProfileView.delegate = self
        
        // Put view to display
        self.view = editProfileView
    }
    
    public func bindToViewModel(viewmodel: EditProfileViewModel) {
        self.viewmodel = viewmodel
    }
}

extension EditProfileViewController : EditProfileViewDelegate {
    
    public func presentUIImagePickerController(imagePicker: UIImagePickerController) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    public func dismissSignUpView(_ handler: CompletionHandler? = nil) {
        self.dismissViewControllerAnimated(true, completion: handler)
    }
}