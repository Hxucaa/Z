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
    
    // nickname
    private var nicknameView: UIView!
    @IBOutlet private weak var nicknameField: UITextField?
    
    // gender
    private var genderPickerView: UIView!
    
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
    private typealias Transition = (view: UIView, completion: (Bool -> Void)?)
    private let (viewTransitionProducer, viewTransitionSink) = SignalProducer<Transition, NoError>.proxy()
    
    
    // MARK: - Setups
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        usernameAndPasswordView = UINib(nibName: UsernameAndPasswordViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UsernameAndPasswordView
        nicknameView = UINib(nibName: NicknameViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        genderPickerView = UINib(nibName: GenderPickerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        birthdayPickerView = UINib(nibName: BirthdayPickerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
    }
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        midStack.addSubview(usernameAndPasswordView)
        centerInSuperview(midStack, subview: usernameAndPasswordView)
        
        compositeDisposable += setupUsernameAndPasswordView
            |> start()
        
        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 8
        
        setupBackButton()
        
        
        /**
        Setup view transition.
        */
        
        // transition to next view.
        compositeDisposable += viewTransitionProducer
            // forwards events along with the previous value. The first member is the previous value and the second is the current value.
            |> combinePrevious((view: self.usernameAndPasswordView, completion: nil))
            |> start(next: { [unowned self] current, next in
                
                // transition animation
                self.animateTransition(current.view, toView: next.view) { success in
                    
                    if let completion = next.completion {
                        completion(success)
                    }
                }
            })
        
        let confirm = Action<UIButton, Void, NSError> { [weak self] button in
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
                                sendNext(this.viewTransitionSink, (this.nicknameView, nil))
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
        
        // Link UIControl event to actions
        confirmButton.addTarget(confirm.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
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
//        confirmButton.rac_enabled <~ viewmodel.allInputsValid
    }
    
    // MARK: Others
    
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
                
                if let completion = completion {
                    completion(finished)
                }
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
