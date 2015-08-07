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


public class Transition {
    private var _view: () -> UIView
    public var view: UIView {
        return _view()
    }
    private var setup: (UIView -> Void)? = nil
    private var afterTransition: (UIView -> Void)? = nil
    private var cleanUp: (UIView -> Void)? = nil
    
    public init(@autoclosure(escaping) view: () -> UIView) {
        self._view = view
    }
    
    public init(@autoclosure(escaping) view: () -> UIView, setup: (UIView -> Void)? = nil, after: (UIView -> Void)? = nil, cleanUp: (UIView -> Void)? = nil) {
        self._view = view
        self.setup = setup
        self.afterTransition = after
        self.cleanUp = cleanUp
    }
    
    public func runSetup() {
        setup?(view)
    }
    
    public func runAfterTransition() {
        afterTransition?(view)
    }
    
    public func runCleanUp() {
        cleanUp?(view)
    }
}

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
    private var usernameAndPasswordView: UsernameAndPasswordView!
    private var submitCocoaAction: CocoaAction!
    private lazy var usernameAndPasswordTransition: Transition = {
        
        let submitAction = Action<UIButton, Void, NSError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    // display HUD to indicate work in progress
                    // check for the validity of inputs first
                    disposable += this.viewmodel.allInputsValid.producer
                        // on error displays error prompt
                        |> on(next: { validity in
                            if !validity {
                                // TODO: implement error prompt
                            }
                        })
                        // only valid inputs can continue through
                        |> filter { $0 }
                        // delay the signal due to the animation of retracting keyboard
                        // this cannot be executed on main thread, otherwise UI will be blocked
                        |> delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                        // return the signal to main/ui thread in order to run UI related code
                        |> observeOn(UIScheduler())
                        //                        |> then(HUD.show())
                        |> flatMap(.Latest) { _ in
                            return HUD.show()
                        }
                        // map error to the same type as other signal
                        |> promoteErrors(NSError)
                        // sign up
                        |> flatMap(.Latest) { _ in
                            return this.viewmodel.signUp
                        }
                        // dismiss HUD based on the result of sign up signal
                        |> HUD.dismissWithStatusMessage(errorHandler: { [weak self] error -> String in
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
                                
                                // interrupts the action
                                // sendInterrupted(sink)
                            }
                    )
                    
                    // Subscribe to disappear notification
                    disposable += HUD.didDissappearNotification()
                        |> on(next: { _ in AccountLogVerbose("HUD disappeared.") })
                        |> start(next: { [weak self] status in
                            if status == HUD.DisappearStatus.Normal {
                                // brings in nickname view
                                sendNext(this.viewTransitionSink, this.nicknameTransition)
                            }
                            
                            // completes the action
                            sendNext(sink, ())
                            sendCompleted(sink)
                            
                            })
                    
                    // Add the signals to CompositeDisposable for automatic memory management
                    disposable.addDisposable {
                        AccountLogVerbose("Sign up action is disposed.")
                    }
                    
                    // retract keyboard
                    self?.endEditing(true)
                }
            }
        }

        
        
        return Transition(
            view: self.usernameAndPasswordView,
            setup: { [weak self] view in
                if let this = self {
                    
                    // Link UIControl event to actions
                    this.confirmButton.addTarget(submitAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
                    
                    this.usernameAndPasswordView.submitProxy
                        |> logLifeCycle(LogContext.Account, "usernameAndPasswordView.submitProxy")
                        |> start(next: {
                            self?.confirmButton.sendActionsForControlEvents(.TouchUpInside)
                        })
                }
            },
            cleanUp: { [weak self] view in
                if let this = self {
                    self?.confirmButton.removeTarget(submitAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
                }
            }
        )

    }()
    
    // nickname
    private var nicknameView: NicknameView!
    private lazy var nicknameTransition: Transition = Transition(
        view: self.nicknameView,
        setup: { [weak self] view in
            if let this = self {
                
                let action = Action<UIButton, Void, NoError> { button in
                    return SignalProducer { sink, disposable in
                        sendNext(this.viewTransitionSink, this.genderPickerTransition)
                        sendCompleted(sink)
                    }
                }
                
                this.confirmButton.setTitle("继续", forState: UIControlState.Normal)
                this.confirmButton.addTarget(action.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
                
                this.nicknameView.continueProxy
                    |> start(next: {
                        self?.confirmButton.sendActionsForControlEvents(.TouchUpInside)
                    })
            }
            
        },
        cleanUp: { [weak self] view in
            
        }
    )
    // gender
    private var genderPickerView: GenderPickerView!
    private lazy var genderPickerTransition: Transition = Transition(
        view: self.genderPickerView,
        setup: { [weak self] view in
            
        },
        after: nil
    )
    
    // birthday
    private var birthdayPickerView: UIView!
    
    // MARK: Bottom Stack
    @IBOutlet private weak var bottomStack: UIView!
    @IBOutlet private weak var confirmButton: UIButton!
    
    // MARK: - Proxies
    
    /// Go back to previous page.
    public var goBackProxy: SimpleProxy {
        return _goBackProxy
    }
    private let (_goBackProxy, _goBackSink) = SimpleProxy.proxy()
    
    /// Sign Up view is finished.
    public var finishSignUpProxy: SimpleProxy {
        return _finishSignUpProxy
    }
    private let (_finishSignUpProxy, _finishSignUpSink) = SimpleProxy.proxy()
    
    // MARK: - Properties
    private var viewmodel: SignUpViewModel!
    
    private let compositeDisposable = CompositeDisposable()
    private let (viewTransitionProducer, viewTransitionSink) = SignalProducer<Transition, NoError>.buffer(0)
    
    private var submitAction: Action<UIButton, Void, NSError>!
    
    // MARK: - Setups
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        usernameAndPasswordView = UINib(nibName: UsernameAndPasswordViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UsernameAndPasswordView
        nicknameView = UINib(nibName: NicknameViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! NicknameView
        genderPickerView = UINib(nibName: GenderPickerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! GenderPickerView
        birthdayPickerView = UINib(nibName: BirthdayPickerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        
    }
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 8
        
        setupBackButton()
        
       
        
        usernameAndPasswordTransition.runSetup()
        // transition animation
        midStack.addSubview(usernameAndPasswordView)
        centerInSuperview(midStack, subview: usernameAndPasswordTransition.view)
        
        /**
        Setup view transition.
        */
        
        // transition to next view.
        compositeDisposable += viewTransitionProducer
            // forwards events along with the previous value. The first member is the previous value and the second is the current value.
            |> combinePrevious(self.usernameAndPasswordTransition)
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
    }
    
    private var setupUsernameAndPasswordView: SignalProducer<Void, NoError> {
        
        return SignalProducer<Void, NoError> { sink, compositeDisposable in
            
            compositeDisposable += self.usernameAndPasswordView.submitProxy
                |> logLifeCycle(LogContext.Account, "usernameAndPasswordView.submitProxy")
                |> start(next: {
                    self.confirmButton.sendActionsForControlEvents(.TouchUpInside)
                })
        }
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
        self.viewmodel = viewmodel
        
        usernameAndPasswordView.bindToViewModel(viewmodel.usernameAndPasswordViewModel)
        
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
        
//        subview.setTranslatesAutoresizingMaskIntoConstraints(false)
//        
//        let centerX = NSLayoutConstraint(item: subview,
//            attribute: NSLayoutAttribute.CenterX,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: superview,
//            attribute: NSLayoutAttribute.CenterX,
//            multiplier: 1.0,
//            constant: 0.0)
//        //        centerX.identifier = "usernameAndPasswordFields to midStack centerX"
//        
//        let topSpacing = NSLayoutConstraint(item: subview,
//            attribute: NSLayoutAttribute.CenterY,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: superview,
//            attribute: NSLayoutAttribute.CenterY,
//            multiplier: 1.0,
//            constant: 0.0)
//        
//        addConstraints(
//            [
//                centerX,
//                topSpacing
//            ]
//        )
        
        let group = layout(subview, superview) { view1, view2 in
            view1.center == view2.center
        }
    }
}
