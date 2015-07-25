//
//  AccountViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

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
    /// A disposable that will dispose of any number of other disposables.
    private let compositeDisposable = CompositeDisposable()
    /**
    A producer that handles transition of views. It also takes in a completion handler after transition is done.
    */
    private let (viewTransitionProducer, viewTransitionSink) = SignalProducer<(view: UIView, completion: (Bool -> Void)?), NoError>.buffer(1)
    
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
        setupTransitions()
        
        // set initial view
        view.addSubview(landingPageView)
        addConstraintsToClipToAllSides(landingPageView)
        
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
                if let this = self {
                    // transition to log in view
                    sendNext(this.viewTransitionSink, (view: this.logInView, completion: { success in this.logInView.startFirstResponder() }))
                }
            })
        
        let signUp = landingPageView.signUpProxy
            |> start(next: { [weak self] in
                if let this = self {
                    // transition to sign up view
                    sendNext(this.viewTransitionSink, (view: this.signUpView, completion: { success in this.signUpView.startFirstResponder() }))
                }
            })
        
        compositeDisposable.addDisposable(skip)
        compositeDisposable.addDisposable(login)
        compositeDisposable.addDisposable(signUp)
    }
    
    private func setupLogIn() {
        logInView.bindToViewModel(viewmodel.logInViewModel)
        
        let goBack = logInView.goBackProxy
            |> start(next: { [weak self] in
                if let this = self {
                    // transition to landing page view
                    sendNext(this.viewTransitionSink, (view: this.landingPageView, completion: nil))
                }
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
        
        compositeDisposable.addDisposable(goBack)
        compositeDisposable.addDisposable(finishLogIn)
    }
    
    private func setupSignUp() {
        signUpView.bindToViewModel(viewmodel.signUpViewModel)
        
        let goBack = signUpView.goBackProxy
            |> start(next: { [weak self] in
                if let this = self {
                    // transition to landing page view
                    sendNext(this.viewTransitionSink, (view: this.landingPageView, completion: nil))
                }
            })

        let finishSignUp = signUpView.finishSignUpProxy
            |> start(next: { [weak self] in
                if let this = self {
                    // transition to edit info view
                    sendNext(this.viewTransitionSink, (view: this.editInfoView, completion: nil))
                }
            })
        
        compositeDisposable.addDisposable(goBack)
        compositeDisposable.addDisposable(finishSignUp)
    }
    
    private func setupEditInfo() {
        editInfoView.bindToViewModel(viewmodel.editProfileViewModel)
        
        let presentUIImagePicker = editInfoView.presentUIImagePickerProxy
            |> start(next: { [weak self] imagePicker in
                // present image picker
                self?.presentViewController(imagePicker, animated: true, completion: nil)
            })
        
        let dismissUIImagePicker = editInfoView.dismissUIImagePickerProxy
            |> start(next: { [weak self] handler in
                // dismiss image picker
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
        
        compositeDisposable.addDisposable(presentUIImagePicker)
        compositeDisposable.addDisposable(dismissUIImagePicker)
        compositeDisposable.addDisposable(finishEditInfo)
    }
    
    private func setupTransitions() {
        
        // transition to next view.
        let viewTransition = viewTransitionProducer
            // forwards events along with the previous value. The first member is the previous value and the second is the current value.
            |> combinePrevious((view: landingPageView, completion: nil))
            |> start(next: { [unowned self] previous, current in
                
                // transition animation
                self.animateTransition(previous.view, toView: current.view) { success in
                    
                    if let completion = current.completion {
                        completion(success)
                    }
                }
            })
        
        compositeDisposable.addDisposable(viewTransition)
    }
    
    deinit {
        // Dispose signals before deinit.
        compositeDisposable.dispose()
        AccountLogVerbose("Account View Controller deinitializes.")
    }
    
    // MARK: Bindings
    
    public func bindToViewModel(viewModel: IAccountViewModel, dismissCallback: CompletionHandler? = nil) {
        self.viewmodel = viewModel
    }
    
    // MARK: Others
    
    /**
    Transition to a view with animation.
    
    :param: fromView   From a UIView.
    :param: toView     To a UIView.
    :param: completion Completion handler which takes in a parameter indicating success.
    */
    private func animateTransition<V: UIView>(fromView: V, toView: V, completion: (Bool -> Void)? = nil) {
        UIView.transitionWithView(
            view,
            duration: 0.5,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { [unowned self] in
                fromView.removeFromSuperview()
                
                self.view.addSubview(toView)
                self.addConstraintsToClipToAllSides(toView)
            },
            completion: { [unowned self] finished in
                
                if let completion = completion {
                    completion(finished)
                }
            }
        )
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