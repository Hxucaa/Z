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
private let LogInViewNibName = "LogInView"
private let LandingPageViewNibName = "LandingPageView"

public final class AccountViewController: XUIViewController {
    
    private var viewmodel: IAccountViewModel!
    private var dismissCallback: CompletionHandler?
    
    private lazy var landingPageView: LandingPageView = NSBundle.mainBundle().loadNibNamed(LandingPageViewNibName, owner: self, options: nil).first as! LandingPageView
    private lazy var logInView: LogInView = NSBundle.mainBundle().loadNibNamed(LogInViewNibName, owner: self, options: nil).first as! LogInView
    private lazy var signUpView: SignUpView = NSBundle.mainBundle().loadNibNamed(SignUpViewNibName, owner: self, options: nil).first as! SignUpView
    private lazy var editInfoView: EditProfileView = NSBundle.mainBundle().loadNibNamed(EditProfileViewNibName, owner: self, options: nil).first as! EditProfileView
    
    public override func loadView() {
        super.loadView()
        
        addLandingViewToSubview()
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
        
        // have to add subview before adding constraints
        view.addSubview(landingPageView)
        
        addConstraintsToClipToAllSides(landingPageView)
    }
    
    private func addLogInViewToSubview() {
        logInView.bindToViewModel(viewmodel.logInViewModel)
        logInView.delegate = self
        view.addSubview(logInView)
        
        addConstraintsToClipToAllSides(logInView)
    }
    
    private func addSignUpViewToSubview() {
        signUpView.bindToViewModel(viewmodel.signUpViewModel)
        signUpView.delegate = self
        view.addSubview(signUpView)
        
        addConstraintsToClipToAllSides(signUpView)
    }
    
    private func addEditInfoViewToSubview() {
        editInfoView.bindToViewModel(viewmodel.editProfileViewModel)
        editInfoView.delegate = self
        view.addSubview(editInfoView)
        
        addConstraintsToClipToAllSides(editInfoView)
    }
    
    /**
    Add constraints that clip to all sides of superview to subview.
    
    :param: subview A UIView.
    */
    private func addConstraintsToClipToAllSides<V: UIView>(subview: V) {
        // turn off autoresizing mask off to allow custom autolayout constraints
        subview.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // add constraints
        view.addConstraints(
            [
                // leading space to view is 0
                NSLayoutConstraint(
                    item: subview,
                    attribute: NSLayoutAttribute.Leading,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: view,
                    attribute: NSLayoutAttribute.Leading,
                    multiplier: 1.0,
                    constant: 0.0
                ),
                // top space to view is 0
                NSLayoutConstraint(
                    item: subview,
                    attribute: NSLayoutAttribute.Top,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: view,
                    attribute: NSLayoutAttribute.Top,
                    multiplier: 1.0,
                    constant: 0.0
                ),
                // trailing space to view is 0
                NSLayoutConstraint(
                    item: subview,
                    attribute: NSLayoutAttribute.Trailing,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: view,
                    attribute: NSLayoutAttribute.Trailing,
                    multiplier: 1.0,
                    constant: 0.0
                ),
                // botom space to view is 0
                NSLayoutConstraint(
                    item: subview,
                    attribute: NSLayoutAttribute.Bottom,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: view,
                    attribute: NSLayoutAttribute.Bottom,
                    multiplier: 1.0,
                    constant: 0.0
                )
            ]
        )
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