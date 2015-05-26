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

    private let imagePicker = UIImagePickerController()
    
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
        // Load nib as view
        signUpView = NSBundle.mainBundle().loadNibNamed(signUpViewNibName, owner: self, options: nil).first as? SignUpView
        // Put view to display
        view = signUpView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signUpView.delegate = self
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //UserService.updateProfilePicture(pickedImage)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SignUpViewController : SignUpViewDelegate {
    public func submitUpdate(#nickname: String, birthday: NSDate) {
        accountVM.updateProfile(nickname, birthday: birthday)
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
    
    public func presentUIImagePickerController() {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    public func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
