//
//  AccountViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SDWebImage

private let EditProfileViewNibName = "EditProfileView"
private let SignUpViewNibName = "SignUpView"
private let LogInViewNibName = "LogInView"
private let LandingPageViewNibName = "LandingPageView"

public final class AccountViewController: XUIViewController {
    
    // MARK: - UI
    // MARK: Controls
    private var landingPageView: LandingPageView!
    private var logInView: LogInView!
    private var signUpView: SignUpView!
    private var editInfoView: EditInfoView!
    
    // MARK: Properties
    private var viewmodel: IAccountViewModel!
    private var landingViewAction: SignalProducer<Void, NoError>!
    private var logInViewAction: SignalProducer<Void, NoError>!
    private var signUpViewAction: SignalProducer<Void, NoError>!
    private var editInfoViewAction: SignalProducer<Void, NoError>!
    private var loadingInitialViewDisposable: Disposable!
    
    // MARK: Setups
    public override func loadView() {
        super.loadView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupLandingPage()
        setupEditInfo()
        setupLogIn()
        setupSignUp()
        
        loadingInitialViewDisposable = landingViewAction |> start()
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        loadingInitialViewDisposable.dispose()
    }
    
    private func setupLandingPage() {
        landingViewAction = SignalProducer { [weak self] sink, disposable in
            if let this = self {
                this.landingPageView = NSBundle.mainBundle().loadNibNamed(LandingPageViewNibName, owner: self, options: nil).first as! LandingPageView
                this.landingPageView.bindToViewModel(this.viewmodel.landingPageViewModel)
                
                let skipDisposable = this.landingPageView.skipProxy
                    |> start(next: {
                        this.viewmodel.skipAccount({
                            this.navigationController?.setNavigationBarHidden(true, animated: false)
                            // dismiss account module, but no callback
                            this.dismissViewControllerAnimated(true, completion: nil)
                        })
                    })
                
                let loginDisposable = this.landingPageView.loginProxy
                    |> then(this.logInViewAction)
                    |> start(next: {
                        this.landingPageView.removeFromSuperview()
                    })
                
                let signUpDisposable = this.landingPageView.signUpProxy
                    |> then(this.signUpViewAction)
                    |> start(next: {
                        this.landingPageView.removeFromSuperview()
                    })
                
                disposable.addDisposable(skipDisposable)
                disposable.addDisposable(loginDisposable)
                disposable.addDisposable(signUpDisposable)
                
                // have to add subview before adding constraints
                this.view.addSubview(this.landingPageView)
                
                this.addConstraintsToClipToAllSides(this.landingPageView)
            }
        }
    }
    
    private func setupLogIn() {
        logInViewAction = SignalProducer { [weak self] sink, disposable in
            if let this = self {
                
                this.logInView = NSBundle.mainBundle().loadNibNamed(LogInViewNibName, owner: self, options: nil).first as! LogInView
                this.logInView.bindToViewModel(this.viewmodel.logInViewModel)
                
                let goBackDisposable = this.logInView.goBackProxy
                    |> then(this.landingViewAction)
                    |> start(next: {
                        this.logInView.removeFromSuperview()
                    })
                
                let finishLogInDisposable = this.logInView.finishLoginProxy
                    |> start(next: {
                        if this.viewmodel.gotoNextModuleCallback == nil {
                            this.viewmodel.pushFeaturedModule()
                        }
                        else {
                            // dismiss account module, and go to the next module
                            this.dismissViewControllerAnimated(true, completion: this.viewmodel.gotoNextModuleCallback)
                        }
                        this.navigationController?.setNavigationBarHidden(false, animated: false)
                    })
                
                disposable.addDisposable(goBackDisposable)
                disposable.addDisposable(finishLogInDisposable)
                
                this.view.addSubview(this.logInView)
                
                this.addConstraintsToClipToAllSides(this.logInView)
            }
        }
    }
    
    private func setupSignUp() {
        
        signUpViewAction = SignalProducer { [weak self] sink, disposable in
            if let this = self {
                
                this.signUpView = NSBundle.mainBundle().loadNibNamed(SignUpViewNibName, owner: self, options: nil).first as! SignUpView
                this.signUpView.bindToViewModel(this.viewmodel.signUpViewModel)
                
                let goBackDisposable = this.signUpView.goBackProxy
                    |> then(this.landingViewAction)
                    |> start(next: {
                        this.signUpView.removeFromSuperview()
                    })
                
                let finishSignUpDisposable = this.signUpView.finishSignUpProxy
                    |> then(this.editInfoViewAction)
                    |> start(next: {
                        this.signUpView.removeFromSuperview()
                    })
                
                disposable.addDisposable(goBackDisposable)
                disposable.addDisposable(finishSignUpDisposable)
                
                this.view.addSubview(this.signUpView)
                
                this.addConstraintsToClipToAllSides(this.signUpView)
            }
        }
    }
    
    private func setupEditInfo() {
        
        editInfoViewAction = SignalProducer { [weak self] sink, disposable in
            if let this = self {
                
                this.editInfoView = NSBundle.mainBundle().loadNibNamed(EditProfileViewNibName, owner: self, options: nil).first as! EditInfoView
                this.editInfoView.delegate = self
                this.editInfoView.bindToViewModel(this.viewmodel.editProfileViewModel)
                
                this.view.addSubview(this.editInfoView)
                
                this.addConstraintsToClipToAllSides(this.editInfoView)
            }
        }
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
    
    // MARK: Bindings
    public func bindToViewModel(viewModel: IAccountViewModel, dismissCallback: CompletionHandler? = nil) {
        self.viewmodel = viewModel
    }
}

extension AccountViewController : EditInfoViewDelegate {
    public func presentUIImagePickerController(imagePicker: UIImagePickerController) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    public func dismissUIImagePickerController(_ handler: CompletionHandler? = nil) {
        dismissViewControllerAnimated(true, completion: handler)
    }
    
    public func editProfileViewFinished() {
        
        if viewmodel.gotoNextModuleCallback == nil {
            viewmodel.pushFeaturedModule()
        }
        else {
            // dismiss account module, and go to the next module
            dismissViewControllerAnimated(true, completion: viewmodel.gotoNextModuleCallback)
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}