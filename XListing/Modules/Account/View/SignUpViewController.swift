//
//  SignInViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

public class SignUpViewController: UIViewController {
    
    private let accountVM: IAccountViewModel
    private let signUpViewNibName: String
    
    private var signUpView: SignUpView!
    
    public init(accountVM: IAccountViewModel, signUpViewNibName: String) {
        self.accountVM = accountVM
        self.signUpViewNibName = signUpViewNibName
        
        super.init(nibName: nil, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        // Load nib as view
        signUpView = NSBundle.mainBundle().loadNibNamed(signUpViewNibName, owner: self, options: nil).first as? SignUpView
        
        // Put view to display
        self.view = signUpView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signUpView.delegate = self
        
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SignUpViewController : SignUpViewDelegate {
    public func submitUpdate(#nickname: String, birthday: NSDate, profileImage: UIImage?) {
        accountVM.updateProfile(nickname, birthday: birthday, profileImage: profileImage)
            .success { [unowned self] success -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            .failure { (error, isCancelled) -> Void in
                if error == nil {
                    println("Operation is cancelled")
                }
                else {
                    println(error)
                }
            }
    }
    
    public func presentUIImagePickerController(imagePicker: UIImagePickerController) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    public func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
