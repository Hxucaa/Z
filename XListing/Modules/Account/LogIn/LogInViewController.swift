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
    private var containerView: ContainerView!
    private var usernameAndPasswordView: UsernameAndPasswordView!
    
    // MARK: - Proxies
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<LogInViewModel?>(nil)
    /// A disposable that will dispose of any number of other disposables.
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override func loadView() {
        super.loadView()
        
        containerView = UINib(nibName: ContainerViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! ContainerView
        
        usernameAndPasswordView = UINib(nibName: UsernameAndPasswordViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UsernameAndPasswordView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        compositeDisposable += usernameAndPasswordView.viewmodel <~ viewmodel.producer
            |> takeUntilViewWillDisappear(self)
            |> ignoreNil
            |> map { $0.usernameAndPasswordViewModel }
        
        
        compositeDisposable += containerView.goBackProxy
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Account, "containerView.goBackProxy")
            |> start(next: { [weak self] in
                // transition to landing page view
                self?.navigationController?.popViewControllerAnimated(false)
            })
        
        compositeDisposable += usernameAndPasswordView.submitProxy
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Account, "usernameAndPasswordView.submitProxy")
            |> start(next: { [weak self] in
                if let viewmodel = self?.viewmodel.value {
                    viewmodel.finishModule { handler in
                        self?.dismissViewControllerAnimated(true, completion: handler)
                    }
                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
                }
            })
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("LogInViewController deinitializes.")
    }
    
    // MARK: - Bindings
    
    // MARK: - Others
}