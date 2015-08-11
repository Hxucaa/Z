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
                            sendNext(this.viewTransitionSink, this.nicknameTransition.transitionActor)
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
                    
                    this.installSubviewButton(view.continueButton)
                    
                    transitionDisposable += view.viewmodel <~ this.viewmodel.producer
                        |> ignoreNil
                        |> map { $0.nicknameViewModel }
                    
                    transitionDisposable += view.continueProxy
                        |> logLifeCycle(LogContext.Account, "usernameAndPasswordView.continueProxy")
                        |> start(next: {
                            sendNext(this.viewTransitionSink, this.genderPickerTransition.transitionActor)
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
                    
                    this.installSubviewButton(view.continueButton)
                    
                    transitionDisposable += view.viewmodel <~ this.viewmodel.producer
                        |> ignoreNil
                        |> map { $0.genderPickerViewModel }
                    
                    transitionDisposable += view.continueProxy
                        |> logLifeCycle(LogContext.Account, "genderPickerView.continueProxy")
                        |> start(next: {
                            sendNext(this.viewTransitionSink, this.birthdayPickerTransition.transitionActor)
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
                    
                    this.installSubviewButton(view.continueButton)
                    
                    transitionDisposable += view.viewmodel <~ this.viewmodel.producer
                        |> ignoreNil
                        |> map { $0.birthdayPickerViewModel }
                    
                    transitionDisposable += view.continueProxy
                        |> logLifeCycle(LogContext.Account, "birthdayPickerView.continueProxy")
                        |> start(next: {
                            sendNext(this.viewTransitionSink, this.photoTransition.transitionActor)
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
                    
                    this.installSubviewButton(view.doneButton)
                    
                    transitionDisposable += view.viewmodel <~ this.viewmodel.producer
                        |> ignoreNil
                        |> map { $0.photoViewModel }
                    
                    transitionDisposable += view.doneProxy
                        |> logLifeCycle(LogContext.Account, "photoView.doneProxy")
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
    @IBOutlet private weak var confirmButton: UIButton!
    
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
    
    // MARK: - Properties
    private let viewmodel = MutableProperty<SignUpViewModel?>(nil)
    
    private let compositeDisposable = CompositeDisposable()
    private let (viewTransitionProducer, viewTransitionSink) = SignalProducer<TransitionActor, NoError>.buffer(0)
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 8
        
        setupBackButton()
        
        /**
        Setup view transition.
        */
        
        // transition to next view.
        compositeDisposable += viewTransitionProducer
            // forwards events along with the previous value. The first member is the previous value and the second is the current value.
            |> combinePrevious(self.usernameAndPasswordTransition.transitionActor)
            |> start(next: { [weak self] current, next in
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
            })
        
        
        
        // display the usernameAndPassword view as the first
        usernameAndPasswordTransition.transitionActor.runSetup()
        // transition animation
        midStack.addSubview(usernameAndPasswordTransition.view)
        centerInSuperview(midStack, subview: usernameAndPasswordTransition.view)
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
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: SignUpViewModel) {
//        self.viewmodel = viewmodel
        self.viewmodel.put(viewmodel)
        
        
        // bind signals
        
        // TODO: implement different validation for different input fields.
        confirmButton.rac_enabled <~ viewmodel.allInputsValid
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
