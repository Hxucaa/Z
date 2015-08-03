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
    
    // MARK: - UI Controls
    private var landingPageView: LandingPageView!
    private var logInView: LogInView!
    private var signUpView: SignUpView!
    private var editInfoView: EditInfoView!
    
    // MARK: - Properties
    
    private var viewmodel: IAccountViewModel!
    /// A disposable that will dispose of any number of other disposables.
    private let compositeDisposable = CompositeDisposable()
    
    /**
    Transition between UIViews is done via sending Transition event through a signal producer. The Transition event is consisted of the view that
    will be transition into and a completion callback. 
    
    The signal producer combines
    */
    private typealias Transition = (view: UIView, completion: (Bool -> Void)?)
    private let (viewTransitionProducer, viewTransitionSink) = SignalProducer<Transition, NoError>.buffer(0)
    
    // MARK: - Setups
    public override func loadView() {
        super.loadView()
        
        landingPageView = UINib(nibName: LandingPageViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! LandingPageView
        
        logInView = UINib(nibName: LogInViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! LogInView
        
        signUpView = UINib(nibName: SignUpViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! SignUpView
        
        editInfoView = UINib(nibName: EditInfoViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! EditInfoView
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // bind view model
        landingPageView.bindToViewModel(viewmodel.landingPageViewModel)
        logInView.bindToViewModel(viewmodel.logInViewModel)
        signUpView.bindToViewModel(viewmodel.signUpViewModel)
        editInfoView.bindToViewModel(viewmodel.editProfileViewModel)
        
        /**
        Setup view transition.
        */
        
        // transition to next view.
        compositeDisposable += viewTransitionProducer
            // forwards events along with the previous value. The first member is the previous value and the second is the current value.
            |> combinePrevious((view: self.landingPageView, completion: nil))
            |> start(next: { [unowned self] current, next in
                
                // transition animation
                self.animateTransition(current.view, toView: next.view) { success in
                    
                    if let completion = next.completion {
                        completion(success)
                    }
                }
            })
        
        
        // add landing page as the first subview
        setupLandingPage()
        view.addSubview(landingPageView)
        addConstraintsToClipToAllSides(landingPageView)
    }
    
    private func setupLandingPage() {
        let landingPageSignal = SignalProducer<Void, NoError> { sink, compositeDisposable in
            
            compositeDisposable += self.landingPageView.skipProxy
                |> logLifeCycle(LogContext.Account, "landingPageView.skipProxy")
                |> start(next: { [weak self] in
                    self?.viewmodel.skipAccount({
                        self?.navigationController?.setNavigationBarHidden(true, animated: false)
                        // dismiss account module, but no callback
                        self?.dismissViewControllerAnimated(true, completion: nil)
                    })
                    sendCompleted(sink)
                })
            
            compositeDisposable += self.landingPageView.loginProxy
                |> logLifeCycle(LogContext.Account, "landingPageView.loginProxy")
                |> start(next: { [weak self] in
                    if let this = self {
                        // transition to log in view
                        sendNext(this.viewTransitionSink, (view: this.logInView, completion: { success in
                            this.setupLogIn()
                            this.logInView.startFirstResponder()
                        }))
                        sendCompleted(sink)
                    }
                })
            
            compositeDisposable += self.landingPageView.signUpProxy
                |> logLifeCycle(LogContext.Account, "landingPageView.signUpProxy")
                |> start(next: { [weak self] in
                    if let this = self {
                        // transition to sign up view
                        sendNext(this.viewTransitionSink, (view: this.signUpView, completion: { success in
                            this.setupSignUp()
                            this.signUpView.startFirstResponder()
                        }))
                        sendCompleted(sink)
                    }
                })
        }
            |> logLifeCycle(LogContext.Account, "landingPageView")
        
        compositeDisposable += landingPageSignal
            |> start()
    }
    
    private func setupLogIn() {
        
        let logInSignal = SignalProducer<Void, NoError> { sink, compositeDisposable in
            
            compositeDisposable += self.logInView.goBackProxy
                |> logLifeCycle(LogContext.Account, "logInView.goBackProxy")
                |> start(next: { [weak self] in
                    if let this = self {
                        // transition to landing page view
                        sendNext(this.viewTransitionSink, (view: this.landingPageView, completion: nil))
                        this.setupLandingPage()
                        sendCompleted(sink)
                    }
                })
            
            compositeDisposable += self.logInView.finishLoginProxy
                |> logLifeCycle(LogContext.Account, "logInView.finishLoginProxy")
                |> start(next: { [weak self] in
                    if self?.viewmodel.gotoNextModuleCallback == nil {
                        self?.viewmodel.pushFeaturedModule()
                    }
                    else {
                        // dismiss account module, and go to the next module
                        self?.dismissViewControllerAnimated(true, completion: self?.viewmodel.gotoNextModuleCallback)
                    }
                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
                    sendCompleted(sink)
                })
        }
            |> logLifeCycle(LogContext.Account, "logIn")
        
        compositeDisposable += logInSignal
            |> start()
    }
    
    private func setupSignUp() {
        
        let setupSignUp = SignalProducer<Void, NoError> { sink, compositeDisposable in
            
            compositeDisposable += self.signUpView.goBackProxy
                |> logLifeCycle(LogContext.Account, "signUpView.goBackProxy")
                |> start(next: { [weak self] in
                    if let this = self {
                        // transition to landing page view
                        sendNext(this.viewTransitionSink, (view: this.landingPageView, completion: nil))
                        this.setupLandingPage()
                        sendCompleted(sink)
                    }
                })
            
            compositeDisposable += self.signUpView.finishSignUpProxy
                |> logLifeCycle(LogContext.Account, "signUpView.finishSignUpProxy")
                |> start(next: { [weak self] in
                    if let this = self {
                        // transition to edit info view
                        sendNext(this.viewTransitionSink, (view: this.editInfoView, completion: nil))
                        this.setupEditInfo()
                        sendCompleted(sink)
                    }
                })
        }
            |> logLifeCycle(LogContext.Account, "signUp")
        
        compositeDisposable += setupSignUp
            |> start()
    }
    
    private func setupEditInfo() {
        
        let setupEditInfo = SignalProducer<Void, NoError> { sink, compositeDisposable in
            
            compositeDisposable += self.editInfoView.presentUIImagePickerProxy
                |> start(next: { [weak self] imagePicker in
                    // present image picker
                    self?.presentViewController(imagePicker, animated: true, completion: nil)
                })
            
            compositeDisposable += self.editInfoView.dismissUIImagePickerProxy
                |> start(next: { [weak self] handler in
                    // dismiss image picker
                    self?.dismissViewControllerAnimated(true, completion: handler)
                })
            
            compositeDisposable += self.editInfoView.finishEditInfoProxy
                |> start(next: { [weak self] in
                    
                    if self?.viewmodel.gotoNextModuleCallback == nil {
                        self?.viewmodel.pushFeaturedModule()
                    }
                    else {
                        // dismiss account module, and go to the next module
                        self?.dismissViewControllerAnimated(true, completion: self?.viewmodel.gotoNextModuleCallback)
                    }
                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
                    sendCompleted(sink)
                })
        }
            |> logLifeCycle(LogContext.Account, "editInfo")
        
        compositeDisposable += setupEditInfo
            |> start()
    }
    
    deinit {
        // Dispose signals before deinit.
        compositeDisposable.dispose()
        AccountLogVerbose("Account View Controller deinitializes.")
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewModel: IAccountViewModel) {
        self.viewmodel = viewModel
    }
    
    // MARK: - Others
    
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