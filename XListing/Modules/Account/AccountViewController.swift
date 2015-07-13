//
//  SignInViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

private let EditProfileViewNibName = "EditProfileView"
private let SignUpViewNibName = "SignUpView"

public final class AccountViewController: XUIViewController {
    
    private var viewmodel: IAccountViewModel!
    private var dismissCallback: CompletionHandler?
    
    private var landingPageView: LandingPageView!
    private var logInView: LogInView!
    private lazy var signUpView: SignUpView = NSBundle.mainBundle().loadNibNamed(SignUpViewNibName, owner: self, options: nil).first as! SignUpView
    private lazy var editInfoView: EditProfileView = NSBundle.mainBundle().loadNibNamed(EditProfileViewNibName, owner: self, options: nil).first as! EditProfileView
    
    public override func loadView() {
        super.loadView()
        logInView = NSBundle.mainBundle().loadNibNamed("LogInView", owner: self, options: nil).first as! LogInView
        landingPageView = NSBundle.mainBundle().loadNibNamed("LandingPageView", owner: self, options: nil).first as! LandingPageView
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func bindToViewModel(viewModel: IAccountViewModel, dismissCallback: CompletionHandler? = nil) {
        self.viewmodel = viewModel
        self.dismissCallback = dismissCallback
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        addLandingViewToSubview()
    }
    
    /**
    Call this to dismiss the view controller
    */
    public func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: dismissCallback)
    }
    
    private func addLandingViewToSubview() {
        landingPageView.bindToViewModel(viewmodel.landingPageViewModel, dismissCallback: nil)
        landingPageView.delegate = self
        view.addSubview(landingPageView)
    }
    
    private func addLogInViewToSubview() {
        logInView.bindToViewModel(viewmodel.logInViewModel)
        logInView.delegate = self
        view.addSubview(logInView)
        
    }
    
    private func addSignUpViewToSubview() {
        signUpView.bindToViewModel(viewmodel.signUpViewModel)
        signUpView.delegate = self
        view.addSubview(signUpView)
    }
    
    private func addEditInfoViewToSubview() {
        editInfoView.bindToViewModel(viewmodel.editProfileViewModel)
        editInfoView.delegate = self
        view.addSubview(editInfoView)
    }
}

extension AccountViewController : LandingViewDelegate {
    public func switchToLoginView() {
//        landingPageView.removeFromSuperview()
        addLogInViewToSubview()
    }
    
    public func switchToSignUpView() {
        addSignUpViewToSubview()
    }
    
    public func skip() {
        viewmodel.skipAccount { [unowned self] in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension AccountViewController : LoginViewDelegate {
    public func goBackToPreviousView() {
        logInView.removeFromSuperview()
    }
}

extension AccountViewController : SignUpViewDelegate {
    public func returnToLandingViewFromSignUp() {
        signUpView.removeFromSuperview()
    }
    
    public func gotoEditInfoView() {
        addEditInfoViewToSubview()
    }
}

extension AccountViewController : EditProfileViewDelegate {
    
    public func presentUIImagePickerController(imagePicker: UIImagePickerController) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    public func dismissSignUpView(_ handler: CompletionHandler? = nil) {
        self.dismissViewControllerAnimated(true, completion: handler)
    }
}