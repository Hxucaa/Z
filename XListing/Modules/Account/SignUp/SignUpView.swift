//
//  SignUpView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-12.
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

public final class SignUpView : UIView {
    
    // MARK: - UI Controls
    
    // MARK: Top Stack
    @IBOutlet private weak var topStack: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var primaryLabel: UILabel!
    @IBOutlet private weak var secondaryLabel: UILabel!
    
    // MARK: Mid Stack
    @IBOutlet private weak var midStack: UIView!
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
                        |> start(next: {
                            this.transitionManager.transitionNext()
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
                    
                    this.backButton.hidden = true
                    
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
                    
                    this.backButton.hidden = true
                    
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
                    
                    this.backButton.hidden = true
                    
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
                    
                    this.backButton.hidden = true
                    
                    this.installSubviewButton(view.doneButton)
                    
                    transitionDisposable += view.viewmodel <~ this.viewmodel.producer
                        |> ignoreNil
                        |> map { $0.photoViewModel }
                    
                    transitionDisposable += view.presentUIImagePickerProxy
                        |> logLifeCycle(LogContext.Account, "photoTransition.presentUIImagePickerProxy")
                        |> start(next: { imagePicker in
                            // present image picker
                            proxyNext(this._presentUIImagePickerSink, imagePicker)
                        })
                    
                    transitionDisposable += view.dismissUIImagePickerProxy
                        |> logLifeCycle(LogContext.Account, "photoTransition.dismissUIImagePickerProxy")
                        |> start(next: { handler in
                            // dismiss image picker
                            proxyNext(this._dismissUIImagePickerSink, handler)
                        })
                    
                    transitionDisposable += view.doneProxy
                        |> logLifeCycle(LogContext.Account, "photoView.doneProxy")
                        |> promoteErrors(NSError)
                        |> flatMap(FlattenStrategy.Concat) { _ in
                            return SignalProducer<Void, NSError> { sink, disposable in
                                
                                if let this = self {
                                    
                                    // Update profile and show the HUD
                                    disposable += SignalProducer<Void, NoError>.empty
                                        // delay the signal due to the animation of retracting keyboard
                                        // this cannot be executed on main thread, otherwise UI will be blocked
                                        |> delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                                        // return the signal to main/ui thread in order to run UI related code
                                        |> observeOn(UIScheduler())
                                        |> then(HUD.show())
                                        // map error to the same type as other signal
                                        |> promoteErrors(NSError)
                                        // update profile
                                        |> then(this.viewmodel.value!.updateProfile)
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
                                                proxyNext(this._finishSignUpSink, ())
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
                                    self?.endEditing(true)
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
    
    
    // MARK: Bottom Stack
    @IBOutlet private weak var bottomStack: UIView!
    
    // MARK: - Proxies
    
    /// Go back to previous page.
    private let (_goBackProxy, _goBackSink) = SimpleProxy.proxy()
    public var goBackProxy: SimpleProxy {
        return _goBackProxy
    }
    
    /// Sign Up view is finished.
    private let (_finishSignUpProxy, _finishSignUpSink) = SimpleProxy.proxy()
    public var finishSignUpProxy: SimpleProxy {
        return _finishSignUpProxy
    }
    
    /// Present UIImage Picker Controller
    public var presentUIImagePickerProxy: SignalProducer<UIImagePickerController, NoError> {
        return _presentUIImagePickerProxy
    }
    private let (_presentUIImagePickerProxy, _presentUIImagePickerSink) = SignalProducer<UIImagePickerController, NoError>.proxy()
    
    /// Dismiss UIImage Picker Controller
    public var dismissUIImagePickerProxy: SignalProducer<CompletionHandler?, NoError> {
        return _dismissUIImagePickerProxy
    }
    private let (_dismissUIImagePickerProxy, _dismissUIImagePickerSink) = SignalProducer<CompletionHandler?, NoError>.proxy()
    
    // MARK: - Properties
    private let viewmodel = MutableProperty<SignUpViewModel?>(nil)
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
            if let this = self, midStack = self?.midStack {
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
                self?.midStack.addSubview(next.view)
                self?.centerInSuperview(this.midStack, subview: next.view)
                next.runAfterTransition()
                // transition animation
//                    this.animateTransition(current.view, toView: next.view) { success in
//
//                        if let afterTransition = next.afterTransition where success {
//                            afterTransition()
//                        }
//                    }
            }
        }
    )
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBackButton()
        
        /**
        Setup view transition.
        */
        transitionManager.installInitial()
    }
    
    private func setupBackButton () {
        let goBackAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { [weak self] sink, disposable in
                self?.endEditing(true)
                
                sendCompleted(sink)
                
                if let this = self {
                    sendNext(this._goBackSink, ())
                }
            }
        }
        
        backButton.addTarget(goBackAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("Sign Up View deinitializes.")
    }
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: SignUpViewModel) {
        self.viewmodel.put(viewmodel)
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
            midStack,
            duration: 0.5,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { [unowned self] in
                fromView.removeFromSuperview()
                
                self.midStack.addSubview(toView)
                self.centerInSuperview(self.midStack, subview: toView)
            },
            completion: { [unowned self] finished in
                
                completion?(finished)
            }
        )
    }
    
    private func centerInSuperview<T: UIView, U: UIView>(superview: T, subview: U) {
        
        let group = layout(subview, superview) { view1, view2 in
            view1.center == view2.center
        }
    }
    
    private func installSubviewButton<T: UIButton>(button: T) {
        
        bottomStack.addSubview(button)
        
        layout(button) { b in
            b.width == button.frame.width
            b.height == button.frame.height
        }
        
        layout(button, bottomStack) { button, stack in
            button.top == stack.top
            button.centerX == stack.centerX
        }
    }
}
