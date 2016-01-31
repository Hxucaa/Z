//
//  LogInViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography

private let UsernameAndPasswordViewNibName = "UsernameAndPasswordView"
private let LogInViewNibName = "LogInView"
private let ContainerViewNibName = "ContainerView"

public final class LogInViewController : XUIViewController {
    
    // MARK: - UI Controls
    private lazy var containerView: ContainerView = {
        return UINib(nibName: ContainerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! ContainerView
    }()
    private lazy var usernameAndPasswordView: UsernameAndPasswordView = {
        return UINib(nibName: UsernameAndPasswordViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UsernameAndPasswordView
    }()
    
    // MARK: - Proxies
    
    // MARK: - Properties
    private var viewmodel: LogInViewModel! {
        didSet {
            usernameAndPasswordView.bindToViewModel(viewmodel.usernameAndPasswordViewModel)
        }
    }
    /// A disposable that will dispose of any number of other disposables.
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameAndPasswordView.setButtonTitle("登 入")
        
        containerView.midStack.addSubview(usernameAndPasswordView)
        
        view = containerView
        
        /**
        *  Setup submit button
        */
        let submitButton = usernameAndPasswordView.signUpButton
        containerView.bottomStack.addSubview(submitButton)
        
        
        constrain(usernameAndPasswordView) { view in
            view.center == view.superview!.center
        }
        
        constrain(submitButton) { b in
            b.width == submitButton.frame.width
            b.height == submitButton.frame.height
        }
        
        constrain(submitButton, containerView.bottomStack) { button, stack in
            button.topMargin == stack.topMargin
            button.centerX == stack.centerX
        }
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
        
        compositeDisposable += usernameAndPasswordView.submitProxy
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Account, signalName: "usernameAndPasswordView.submitProxy")
            .promoteErrors(NSError)
            .flatMap(FlattenStrategy.Concat) {
                SignalProducer<Void, NSError> { observer, disposable in
                    // display HUD to indicate work in progress
                    // check for the validity of inputs first
                    disposable += SignalProducer<Void, NoError>(value: ())
                        // delay the signal due to the animation of retracting keyboard
                        // this cannot be executed on main thread, otherwise UI will be blocked
                        .delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                        // return the signal to main/ui thread in order to run UI related code
                        .observeOn(UIScheduler())
                        .flatMap(.Concat) { _ in
                            return HUD.show()
                        }
                        // map error to the same type as other signal
                        .promoteErrors(NSError)
                        // submit network request
                        .flatMap(.Concat) { _ in
                            return self.viewmodel.logIn
                        }
                        // does not `sendCompleted` because completion is handled when HUD is disappeared
                        .start { event in
                            switch event {
                            case .Next(_):
                                HUD.dismissWithNextMessage()
                            case .Failed(let error):
                                HUD.dismissWithFailedMessage()
                                AccountLogError(error.description)
                                observer.sendFailed(error)
                            case .Interrupted:
                                observer.sendInterrupted()
                            default: break
                            }
                    }
                    
                    // TODO: Disallow user to cancel network request
//                    // Subscribe to touch down inside event
//                    disposable += HUD.didTouchDownInsideNotification()
//                        .on(next: { _ in AccountLogVerbose("HUD touch down inside.") })
//                        .startWithNext { _ in
//                            // dismiss HUD
//                            HUD.dismiss()
//                            
//                            // interrupts the action
//                            // sendInterrupted(observer)
//                    }
                    
                    
                    // Subscribe to disappear notification
                    disposable += HUD.didDissappearNotification()
                        .on(next: { _ in AccountLogVerbose("HUD disappeared.") })
                        .startWithNext { status in
                            // completes the action
                            observer.sendNext(())
                            observer.sendCompleted()
                    }
                }

            }
            .startWithNext { [weak self] in
                self?.viewmodel.finishModule { handler in
                    self?.dismissViewControllerAnimated(true, completion: handler)
                }
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
            }
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("LogInViewController deinitializes.")
    }
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: LogInViewModel) {
        self.viewmodel = viewmodel
        
    }
    
    // MARK: - Others
}