//
//  SignInViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

public final class AccountViewController: UIViewController {
    
    private var accountVM: IAccountViewModel!
    private var editProfileViewNibName: String!
    
    private var editProfileView: EditProfileView!
    
    public func bindToViewModel(accountViewModel: IAccountViewModel, editProfileViewNibName: String) {
        self.accountVM = accountViewModel
        self.editProfileViewNibName = editProfileViewNibName
    }
    
    public override func loadView() {
        super.loadView()
        
        // Load nib as view
        editProfileView = NSBundle.mainBundle().loadNibNamed(editProfileViewNibName, owner: self, options: nil).first as? EditProfileView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        displaySignUpView()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func displaySignUpView() {
        editProfileView.delegate = self
        editProfileView.bindToViewModel(accountVM.editProfileViewModel)
        
        // Put view to display
        self.view = editProfileView
    }
}

extension AccountViewController : EditProfileViewDelegate {
    
    public func presentUIImagePickerController(imagePicker: UIImagePickerController) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    public var dismissSignUpView: CompletionHandler? -> Void {
        return { (completionHandler: CompletionHandler?) -> Void in
            self.dismissViewControllerAnimated(true, completion: completionHandler)
        }
    }
}
