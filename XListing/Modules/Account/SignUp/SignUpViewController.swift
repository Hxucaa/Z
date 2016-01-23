//
//  SignUpViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography

private let UsernameAndPasswordViewNibName = "UsernameAndPasswordView"
private let NicknameViewNibName = "NicknameView"
private let GenderPickerViewNibName = "GenderPickerView"
private let BirthdayPickerViewNibName = "BirthdayPickerView"
private let PhotoViewNibName = "PhotoView"
private let ContainerViewNibName = "ContainerView"

/**
The sign up interface is composed of several different UIViews. The ContainerView, three UIViews vertically stacked, is the base of the interface. The top stack is hosts brand label and back button. The middle stack hosts several different ui elements that require users interactions. The UI elements are separated into several XIB files and are loaded at runtime during different stages of user interation. The bottom stack hosts submit or continue buttons, depending on the UI elements loaded in the middle stack.

The challenge of implementation is to figure out an intuitive and easy to understand/maintain way to transition between different UI elements. For example, the `UsernameAndPasswordView` contains the textfield for username and password. It also contains the submit button which starts a network request. When loading the `UsernameAndPasswordView`, the textfields are placed horizontally and vertically centered in the middle stack. The button, designed only programatically (not on XIB file), is placed programatically in the bottom stack. The placement of the aforementioned UI elements are done programatically via autolayout. When it comes to transition to the next set of UI elements, for instance, the `NicknameView`, the previous set of elements in both the middle stack and the bottom stack have to be removed. Then the new elements are loaded. The same method repeats itself until the last transition.

A custom `Transition` and `TransitionManager` are implemented to handle the above scenarios. Each `Transition` object contains 4 items: I) UIView, that is going to be transitioned into. II) Setup, the setup code that is going to be run before the transition starts to properly configure the UIView. III) After, code that runs right after the transition is done. IV) CleanUp, which cleans up the current transition as it goes away. The `TransitionManager` takes 4 items: I) the initial transition, II) the rest of the transitions, III) the behaviour of the initial transition, III) the behaviour of the rest of the transitions.
*/

public final class SignUpViewController : XUIViewController {
    
    // MARK: - UI Controls
    private var containerView: ContainerView!
    
    // MARK: - Proxies
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<SignUpViewModel?>(nil)
    
    /// A disposable that will dispose of any number of other disposables.
    private let compositeDisposable = CompositeDisposable()
    
    /// a TransitionManager which manages the transitions
    private lazy var transitionManager: TransitionManager = TransitionManager(
        initial: self.usernameAndPasswordTransition.transitionActor,
        // note that the transitions are wrapped in closures so that they will be loaded on demand instead of during initialization
        
        // swiftlint:disable:next opening_brace
        followUps: [
            { self.nicknameTransition.transitionActor },
            { self.genderPickerTransition.transitionActor },
            { self.birthdayPickerTransition.transitionActor },
            { self.photoTransition.transitionActor }
        ],
        // swiftlint:disable:previous opening_brace
        
        initialTransformation: { [weak self] transition in
            if let this = self, midStack = self?.containerView.midStack {
                // display the usernameAndPassword view as the first
                transition.runSetup()
                // transition animation
                midStack.addSubview(transition.view)
                this.centerInSuperview(midStack, subview: transition.view)
            }
        },
        transformation: { [weak self] (current, next) in
            if let this = self {
                
                // remove the current transition first
                current.view.removeFromSuperview()
                current.runCleanUp()
                
                // start the next transition
                next.runSetup()
                self?.containerView.midStack.addSubview(next.view)
                self?.centerInSuperview(this.containerView.midStack, subview: next.view)
                
                // after code for the transition
                next.runAfterTransition()
            }
        }
    )
    
    // MARK: - Setups
    
    public override func loadView() {
        super.loadView()
        
        // load container
        containerView = UINib(nibName: ContainerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! ContainerView
        view = containerView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        /**
        Setup view transition.
        */
        transitionManager.installInitial()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        compositeDisposable += containerView.goBackProxy
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Account, signalName: "containerView.goBackProxy")
            .startWithNext { [weak self] in
                // transition to landing page view
                self?.navigationController?.popViewControllerAnimated(false)
            }
    }
    
    // username and password
    private lazy var usernameAndPasswordTransition: Transition<UsernameAndPasswordView> = {
        
        let transitionDisposable = CompositeDisposable()
        
        return Transition(
            view: UINib(nibName: UsernameAndPasswordViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UsernameAndPasswordView,
            setup: { [weak self] view in
                if let this = self {
                    
                    this.installSubviewButton(view.signUpButton)
                    
                    transitionDisposable += view.viewmodel <~ this.viewmodel.producer
                        .ignoreNil()
                        .map { $0.usernameAndPasswordViewModel }
                    
                    transitionDisposable += view.submitProxy
                        .logLifeCycle(LogContext.Account, signalName: "usernameAndPasswordView.submitProxy")
                        .startWithNext { [weak self] in
                            self?.transitionManager.transitionNext()
                        }
                    
                }
            },
            cleanUp: { [weak self] view in
                view.signUpButton.removeFromSuperview()
                transitionDisposable.dispose()
            }
        )
    }()
    
    // nickname
    private lazy var nicknameTransition: Transition<NicknameView> = {
        
        let transitionDisposable = CompositeDisposable()
        
        return Transition(
            view: UINib(nibName: NicknameViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! NicknameView,
            setup: { [weak self] view in
                if let this = self {
                    
                    this.containerView.backButton.hidden = true
                    
                    this.installSubviewButton(view.continueButton)
                    
                    transitionDisposable += view.viewmodel <~ this.viewmodel.producer
                        .ignoreNil()
                        .map { $0.nicknameViewModel }
                    
                    transitionDisposable += view.continueProxy
                        .logLifeCycle(LogContext.Account, signalName: "usernameAndPasswordView.continueProxy")
                        .startWithNext {
                            this.transitionManager.transitionNext()
                        }
                }
                
            },
            cleanUp: { [weak self] view in
                view.continueButton.removeFromSuperview()
                transitionDisposable.dispose()
            }
        )
    }()
    
    // gender
    private lazy var genderPickerTransition: Transition<GenderPickerView> = {
        
        let transitionDisposable = CompositeDisposable()
        
        return Transition(
            view: UINib(nibName: GenderPickerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! GenderPickerView,
            setup: { [weak self] view in
                if let this = self {
                    
                    this.containerView.backButton.hidden = true
                    
                    this.installSubviewButton(view.continueButton)
                    
                    transitionDisposable += view.viewmodel <~ this.viewmodel.producer
                        .ignoreNil()
                        .map { $0.genderPickerViewModel }
                    
                    transitionDisposable += view.continueProxy
                        .logLifeCycle(LogContext.Account, signalName: "genderPickerView.continueProxy")
                        .startWithNext {
                            this.transitionManager.transitionNext()
                        }
                }
            },
            cleanUp: { [weak self] view in
                view.continueButton.removeFromSuperview()
                transitionDisposable.dispose()
            }
        )
    }()
    
    // birthday
    private lazy var birthdayPickerTransition: Transition<BirthdayPickerView> = {
        
        let transitionDisposable = CompositeDisposable()
        
        return Transition(
            view: UINib(nibName: BirthdayPickerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! BirthdayPickerView,
            setup: { [weak self] view in
                
                if let this = self {
                    
                    this.containerView.backButton.hidden = true
                    
                    this.installSubviewButton(view.continueButton)
                    
                    transitionDisposable += view.viewmodel <~ this.viewmodel.producer
                        .ignoreNil()
                        .map { $0.birthdayPickerViewModel }
                    
                    transitionDisposable += view.continueProxy
                        .logLifeCycle(LogContext.Account, signalName: "birthdayPickerView.continueProxy")
                        .startWithNext {
                            this.transitionManager.transitionNext()
                        }
                }
                
            },
            cleanUp: { [weak self] view in
                view.continueButton.removeFromSuperview()
                transitionDisposable.dispose()
            }
        )
    }()
    
    // photo
    private lazy var photoTransition: Transition<PhotoView> = {
        
        let transitionDisposable = CompositeDisposable()
        
        return Transition(
            view: UINib(nibName: PhotoViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! PhotoView,
            setup: { [weak self] view in
                
                if let this = self {
                    
                    this.containerView.backButton.hidden = true
                    
                    this.installSubviewButton(view.doneButton)
                    
                    transitionDisposable += view.viewmodel <~ this.viewmodel.producer
                        .ignoreNil()
                        .map { $0.photoViewModel }
                    
                    transitionDisposable += view.presentUIImagePickerProxy
                        .logLifeCycle(LogContext.Account, signalName: "photoView.presentUIImagePickerProxy")
                        .startWithNext { imagePicker in
                            // present image picker
                            self?.presentViewController(imagePicker, animated: true, completion: nil)
                        }
                    
                    transitionDisposable += view.dismissUIImagePickerProxy
                        .logLifeCycle(LogContext.Account, signalName: "photoView.dismissUIImagePickerProxy")
                        .startWithNext { handler in
                            // dismiss image picker
                            self?.dismissViewControllerAnimated(true, completion: handler)
                        }
                    
                    transitionDisposable += view.doneProxy
                        .logLifeCycle(LogContext.Account, signalName: "photoView.doneProxy")
                        .startWithNext {
                            if let viewmodel = self?.viewmodel.value {
                                viewmodel.finishModule { handler in
                                    self?.dismissViewControllerAnimated(true, completion: handler)
                                }
                                
                                self?.navigationController?.setNavigationBarHidden(false, animated: false)
                            }
                        }
                }
                
            },
            cleanUp: { [weak self] view in
                view.doneButton.removeFromSuperview()
                transitionDisposable.dispose()
            }
        )
    }()
    
    
    deinit {
        // Dispose signals before deinit.
        compositeDisposable.dispose()
        AccountLogVerbose("SignUp View Controller deinitializes.")
    }
    
    // MARK: - Others
    
    /**
    Place the subview in the center, horizontally and vertically, of the superview.
    
    - parameter superview: Superview
    - parameter subview:   Subview
    */
    private func centerInSuperview<T: UIView, U: UIView>(superview: T, subview: U) {
        
        constrain(subview, superview) { view1, view2 in
            view1.center == view2.center
        }
    }
    
    /**
    Install a button in the bottom stack.
    
    - parameter button: The UIButton.
    */
    private func installSubviewButton<T: UIButton>(button: T) {
        
        containerView.bottomStack.addSubview(button)
        
        constrain(button) {
            $0.width == button.frame.width
            $0.height == button.frame.height
        }
        
        constrain(button, containerView.bottomStack) {
            $0.topMargin == $1.topMargin
            $0.centerX == $1.centerX
        }
    }
}