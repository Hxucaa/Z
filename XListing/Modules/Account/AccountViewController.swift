//
//  AccountViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Dollar

private let EditInfoViewNibName = "EditInfoView"
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
    private var disposables = [Disposable]()
    
    // MARK: Setups
    public override func loadView() {
        super.loadView()
        
        landingPageView = NSBundle.mainBundle().loadNibNamed(LandingPageViewNibName, owner: self, options: nil).first as! LandingPageView
        
        logInView = NSBundle.mainBundle().loadNibNamed(LogInViewNibName, owner: self, options: nil).first as! LogInView
        
        signUpView = NSBundle.mainBundle().loadNibNamed(SignUpViewNibName, owner: self, options: nil).first as! SignUpView
        
        editInfoView = NSBundle.mainBundle().loadNibNamed(EditInfoViewNibName, owner: self, options: nil).first as! EditInfoView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        setupLandingPage()
        setupLogIn()
        setupSignUp()
        setupEditInfo()
        
        showLandingPageView()
    }
    
    private func setupLandingPage() {
        landingPageView.bindToViewModel(viewmodel.landingPageViewModel)
        
        let skip = landingPageView.skipProxy
            |> start(next: { [weak self] in
                self?.viewmodel.skipAccount({
                    self?.navigationController?.setNavigationBarHidden(true, animated: false)
                    // dismiss account module, but no callback
                    self?.dismissViewControllerAnimated(true, completion: nil)
                })
            })
        
        let login = landingPageView.loginProxy
            |> start(next: { [weak self] in
                self?.showLogInView()
            })
        
        let signUp = landingPageView.signUpProxy
            |> start(next: { [weak self] in
                self?.showSignUpView()
            })
        
        disposables.append(skip)
        disposables.append(login)
        disposables.append(signUp)
    }
    
    private func setupLogIn() {
        logInView.bindToViewModel(viewmodel.logInViewModel)
        
        let goBack = logInView.goBackProxy
            |> start(next: { [weak self] in
                self?.showLandingPageView()
            })
        
        let finishLogIn = logInView.finishLoginProxy
            |> start(next: { [weak self] in
                if self?.viewmodel.gotoNextModuleCallback == nil {
                    self?.viewmodel.pushFeaturedModule()
                }
                else {
                    // dismiss account module, and go to the next module
                    self?.dismissViewControllerAnimated(true, completion: self?.viewmodel.gotoNextModuleCallback)
                }
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
            })
        
        disposables.append(goBack)
        disposables.append(finishLogIn)
    }
    
    private func setupSignUp() {
        signUpView.bindToViewModel(viewmodel.signUpViewModel)
        
        let goBack = signUpView.goBackProxy
            |> start(next: { [weak self] in
                self?.showLandingPageView()
            })

        let finishSignUp = signUpView.finishSignUpProxy
            |> start(next: { [weak self] in
                self?.showEditInfoView()
            })
        
        disposables.append(goBack)
        disposables.append(finishSignUp)
    }
    
    private func setupEditInfo() {
        editInfoView.bindToViewModel(viewmodel.editProfileViewModel)
        
        let presentUIImagePicker = editInfoView.presentUIImagePickerProxy
            |> start(next: { [weak self] imagePicker in
                self?.presentViewController(imagePicker, animated: true, completion: nil)
            })
        
        let dismissUIImagePicker = editInfoView.dismissUIImagePickerProxy
            |> start(next: { [weak self] handler in
                self?.dismissViewControllerAnimated(true, completion: handler)
            })
        
        let finishEditInfo = editInfoView.finishEditInfoProxy
            |> start(next: { [weak self] in
                
                if self?.viewmodel.gotoNextModuleCallback == nil {
                    self?.viewmodel.pushFeaturedModule()
                }
                else {
                    // dismiss account module, and go to the next module
                    self?.dismissViewControllerAnimated(true, completion: self?.viewmodel.gotoNextModuleCallback)
                }
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
            })
        
        disposables.append(presentUIImagePicker)
        disposables.append(dismissUIImagePicker)
        disposables.append(finishEditInfo)
    }
    
    deinit {
        // Dispose signals before deinit.
        $.each(disposables) { $0.dispose() }
        AccountLogVerbose("Account View Controller deinitializes.")
    }
    
    // MARK: Bindings
    
    public func bindToViewModel(viewModel: IAccountViewModel, dismissCallback: CompletionHandler? = nil) {
        self.viewmodel = viewModel
    }
    
    // MARK: Others
    
    private func showLandingPageView() {
        view = landingPageView
    }
    
    private func showSignUpView() {
        view = signUpView
        signUpView.startFirstResponder()
    }
    
    private func showLogInView() {
        view = logInView
        logInView.startFirstResponder()
    }
    
    private func showEditInfoView() {
        view = editInfoView
    }
}