//
//  SignInViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

public final class SignUpViewController: UIViewController {
    
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
        signUpView.delegate = self
        signUpView.bindToViewModel(accountVM.signUpViewModel)
        
        // Put view to display
        self.view = signUpView
    }
}

extension SignUpViewController : SignUpViewDelegate {
    
    public func presentUIImagePickerController(imagePicker: UIImagePickerController) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    public var dismissSignUpView: CompletionHandler? -> Void {
        return { (completionHandler: CompletionHandler?) -> Void in
            self.dismissViewControllerAnimated(true, completion: completionHandler)
        }
    }
}
