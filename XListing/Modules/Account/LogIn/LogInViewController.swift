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

final class LogInViewController : XUIViewController, ViewModelBackedViewControllerType {
    
    typealias ViewModelType = ILogInViewModel
    
    // MARK: - UI Controls
    private lazy var containerView: ContainerView = {
        return UINib(nibName: ContainerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! ContainerView
    }()
    private lazy var usernameAndPasswordView: UsernameAndPasswordView = {
        return UINib(nibName: UsernameAndPasswordViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UsernameAndPasswordView
    }()
    var hud: HUD!
    
    // MARK: - Proxies
    
    // MARK: - Properties
    private var viewmodel: ILogInViewModel!
    
    // MARK: - Setups
    
    override func viewDidLoad() {
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        _compositeDisposable += containerView.goBackProxy
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Account, signalName: "containerView.goBackProxy")
            .startWithNext { [weak self] in
                // transition to landing page view
                self?.navigationController?.popViewControllerAnimated(false)
            }
        
        _compositeDisposable += usernameAndPasswordView.submitProxy
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Account, signalName: "usernameAndPasswordView.submitProxy")
            .promoteErrors(NetworkError)
            .flatMap(FlattenStrategy.Concat) {
                SignalProducer<Void, NetworkError> { observer, disposable in
                    // display HUD to indicate work in progress
                    // check for the validity of inputs first
                    disposable += SignalProducer<Void, NoError>(value: ())
                        // delay the signal due to the animation of retracting keyboard
                        // this cannot be executed on main thread, otherwise UI will be blocked
                        .delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                        // return the signal to main/ui thread in order to run UI related code
                        .observeOn(UIScheduler())
                        .flatMap(.Concat) { _ in
                            return self.hud.show()
                        }
                        // map error to the same type as other signal
                        .promoteErrors(NetworkError)
                        // submit network request
                        .flatMap(.Concat) { _ in
                            return self.viewmodel.logIn
                        }
                        // does not `sendCompleted` because completion is handled when HUD is disappeared
                        .start { event in
                            switch event {
                            case .Next(_):
                                self.hud.dismissWithNextMessage()
                            case .Failed(let error):
                                self.hud.dismissWithFailedMessage()
                                AccountLogError(error.message)
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
                    disposable += self.hud.didDissappearNotification()
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
    
    
    // MARK: - Bindings
    func bindToViewModel(viewmodel: ILogInViewModel) {
        self.viewmodel = viewmodel
        usernameAndPasswordView.bindToViewModel(viewmodel.usernameAndPasswordViewModel)
        
    }
    
    // MARK: - Others
}