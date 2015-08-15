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

public final class SignUpViewController : XUIViewController {
    
    // MARK: - UI Controls
    private var containerView: ContainerView!
    
    // MARK: - Proxies
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<SignUpViewModel?>(nil)
    /// A disposable that will dispose of any number of other disposables.
    private let compositeDisposable = CompositeDisposable()
    private lazy var transitionManager: TransitionManager = TransitionManager(
        initial: self.usernameAndPasswordTransition.transitionActor,
        followUps: [
            self.nicknameTransition.transitionActor,
            self.genderPickerTransition.transitionActor,
            self.birthdayPickerTransition.transitionActor,
            self.photoTransition.transitionActor
        ],
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
                
                current.view.removeFromSuperview()
                current.runCleanUp()
                next.runSetup()
                self?.containerView.midStack.addSubview(next.view)
                self?.centerInSuperview(this.containerView.midStack, subview: next.view)
                next.runAfterTransition()
            }
        }
    )
    
    // MARK: - Setups
    
    public override func loadView() {
        super.loadView()
        
        containerView = UINib(nibName: ContainerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! ContainerView
        view = containerView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
//        containerView.viewmodel <~ viewmodel
        
        compositeDisposable += containerView.goBackProxy
            |> logLifeCycle(LogContext.Account, "signUpView.goBackProxy")
            |> start(next: { [weak self] in
                if let this = self {
                    // transition to landing page view
                    //                    proxyNext(this._goBackSink, ())
                    self?.navigationController?.popViewControllerAnimated(false)
                }
            })
        
//        compositeDisposable += containerView.finishSignUpProxy
//            |> logLifeCycle(LogContext.Account, "signUpView.finishSignUpProxy")
//            |> start(next: { [weak self] in
//                if let viewmodel = self?.viewmodel.value {
//                    viewmodel.goToFeaturedModule { handler in
//                        self?.dismissViewControllerAnimated(true, completion: handler)
//                    }
//                    
//                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
//                }
//            })
//        
//        compositeDisposable += signUpView.presentUIImagePickerProxy
//            |> logLifeCycle(LogContext.Account, "signUpView.presentUIImagePickerProxy")
//            |> start(next: { [weak self] imagePicker in
//                // present image picker
//                self?.presentViewController(imagePicker, animated: true, completion: nil)
//            })
//        
//        compositeDisposable += signUpView.dismissUIImagePickerProxy
//            |> logLifeCycle(LogContext.Account, "signUpView.dismissUIImagePickerProxy")
//            |> start(next: { [weak self] handler in
//                // dismiss image picker
//                self?.dismissViewControllerAnimated(true, completion: handler)
//            })
        
        
        /**
        Setup view transition.
        */
        transitionManager.installInitial()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        // Dispose signals before deinit.
        compositeDisposable.dispose()
        AccountLogVerbose("SignUp View Controller deinitializes.")
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
                        |> ignoreNil
                        |> map { $0.usernameAndPasswordViewModel }
                    
                    transitionDisposable += view.submitProxy
                        |> logLifeCycle(LogContext.Account, "usernameAndPasswordView.submitProxy")
                        |> start(next: { [weak self] in
                            self?.transitionManager.transitionNext()
                        })
                    
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
                        |> ignoreNil
                        |> map { $0.nicknameViewModel }
                    
                    transitionDisposable += view.continueProxy
                        |> logLifeCycle(LogContext.Account, "usernameAndPasswordView.continueProxy")
                        |> start(next: {
                            this.transitionManager.transitionNext()
                        })
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
                        |> ignoreNil
                        |> map { $0.genderPickerViewModel }
                    
                    transitionDisposable += view.continueProxy
                        |> logLifeCycle(LogContext.Account, "genderPickerView.continueProxy")
                        |> start(next: {
                            this.transitionManager.transitionNext()
                        })
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
                        |> ignoreNil
                        |> map { $0.birthdayPickerViewModel }
                    
                    transitionDisposable += view.continueProxy
                        |> logLifeCycle(LogContext.Account, "birthdayPickerView.continueProxy")
                        |> start(next: {
                            this.transitionManager.transitionNext()
                        })
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
                        |> ignoreNil
                        |> map { $0.photoViewModel }
                    
                    transitionDisposable += view.presentUIImagePickerProxy
                        |> logLifeCycle(LogContext.Account, "photoTransition.presentUIImagePickerProxy")
                        |> start(next: { imagePicker in
                            // present image picker
                            //                            proxyNext(this._presentUIImagePickerSink, imagePicker)
                            self?.presentViewController(imagePicker, animated: true, completion: nil)
                        })
                    
                    transitionDisposable += view.dismissUIImagePickerProxy
                        |> logLifeCycle(LogContext.Account, "photoTransition.dismissUIImagePickerProxy")
                        |> start(next: { handler in
                            // dismiss image picker
                            //                            proxyNext(this._dismissUIImagePickerSink, handler)
                            self?.dismissViewControllerAnimated(true, completion: handler)
                        })
                    
                    transitionDisposable += view.doneProxy
                        |> logLifeCycle(LogContext.Account, "photoView.doneProxy")
                        |> promoteErrors(NSError)
                        |> flatMap(FlattenStrategy.Concat) { _ in
                            return SignalProducer<Void, NSError> { sink, disposable in
                                
                                if let this = self, viewmodel = self?.viewmodel.value {
                                    
                                    // Update profile and show the HUD
                                    disposable += viewmodel.areAllProfileInputsPresent.producer
                                        // only valid input goes through
                                        |> filter { $0 }
                                        //                                        SignalProducer<Void, NoError>.empty
                                        // delay the signal due to the animation of retracting keyboard
                                        // this cannot be executed on main thread, otherwise UI will be blocked
                                        |> delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                                        // return the signal to main/ui thread in order to run UI related code
                                        |> observeOn(UIScheduler())
                                        |> flatMap(.Concat) { _ in
                                            return HUD.show()
                                        }
                                        // map error to the same type as other signal
                                        |> promoteErrors(NSError)
                                        // update profile
                                        |> flatMap(.Concat) { _ in
                                            return viewmodel.updateProfile
                                        }
                                        // dismiss HUD based on the result of update profile signal
                                        |> HUD.dismissWithStatusMessage(errorHandler: { error -> String in
                                            AccountLogError(error.description)
                                            return error.customErrorDescription
                                        })
                                        // does not `sendCompleted` because completion is handled when HUD is disappeared
                                        |> start(
                                            error: { error in
                                                sendError(sink, error)
                                            },
                                            interrupted: { _ in
                                                sendInterrupted(sink)
                                            }
                                    )
                                    
                                    // Subscribe to touch down inside event
                                    disposable += HUD.didTouchDownInsideNotification()
                                        |> on(next: { _ in AccountLogVerbose("HUD touch down inside.") })
                                        |> start(
                                            next: { _ in
                                                // dismiss HUD
                                                HUD.dismiss()
                                            }
                                    )
                                    
                                    // Subscribe to disappear notification
                                    disposable += HUD.didDissappearNotification()
                                        |> on(next: { _ in AccountLogVerbose("HUD disappeared.") })
                                        |> start(next: { status in
                                            if status == HUD.DisappearStatus.Normal {
                                                //                                                proxyNext(this._finishSignUpSink, ())
                                                if let viewmodel = self?.viewmodel.value {
                                                    viewmodel.goToFeaturedModule { handler in
                                                        self?.dismissViewControllerAnimated(true, completion: handler)
                                                    }
                                                    
                                                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
                                                }
                                            }
                                            
                                            // completes the action
                                            sendNext(sink, ())
                                            sendCompleted(sink)
                                        })
                                    
                                    // Add the signals to CompositeDisposable for automatic memory management
                                    disposable.addDisposable {
                                        AccountLogVerbose("Update profile action is disposed.")
                                    }
                                    
                                    // retract keyboard
                                    self?.view.endEditing(true)
                                }
                            }
                        }
                        |> start(next: {
                            
                        })
                }
                
            },
            cleanUp: { [weak self] view in
                view.doneButton.removeFromSuperview()
                transitionDisposable.dispose()
            }
        )
    }()
    
    // MARK: - Others
    
    private func centerInSuperview<T: UIView, U: UIView>(superview: T, subview: U) {
        
        let group = constrain(subview, superview) { view1, view2 in
            view1.center == view2.center
        }
    }
    
    private func installSubviewButton<T: UIButton>(button: T) {
        
        containerView.bottomStack.addSubview(button)
        
        layout(button) { b in
            b.width == button.frame.width
            b.height == button.frame.height
        }
        
        layout(button, containerView.bottomStack) { button, stack in
            button.topMargin == stack.topMargin
            button.centerX == stack.centerX
        }
    }
}