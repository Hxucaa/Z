//
//  LogInViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-05.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Cartography

private let UsernameAndPasswordViewNibName = "UsernameAndPasswordView"
private let LogInViewNibName = "LogInView"
private let ContainerViewNibName = "ContainerView"

final class LogInViewController : XUIViewController, ViewModelBackedViewControllerType {
    
    typealias InputViewModel = (username: ControlProperty<String>, password: ControlProperty<String>, submitTrigger: ControlEvent<Void>) -> ILogInViewModel
    
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
    private var inputViewModel: InputViewModel!
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
        
        viewmodel = inputViewModel(
            username: usernameAndPasswordView.usernameFieldText,
            password: usernameAndPasswordView.passwordFieldText,
            submitTrigger: usernameAndPasswordView.submitTap
        )
        
        usernameAndPasswordView.bindToData(viewmodel.submissionEnabled)
        
        usernameAndPasswordView.submitTap
            .subscribeNext { [weak self] in
                self?.view.endEditing(true)
            }
            .addDisposableTo(disposeBag)
        
        containerView.backButtonTap
            .subscribeNext { [weak self] in
                self?.navigationController?.popViewControllerAnimated(false)
            }
            .addDisposableTo(disposeBag)
        
        viewmodel.formStatus
            .subscribeNext { [weak self] in
                switch $0 {
                case .Error:
                    self?.hud.dismissWithFailedMessage()
                case .Submitting:
                    self?.hud.x_showWithStatusMessage()
                case .Submitted:
                    self?.hud.dismissWithCompletedMessage()
                    self?.viewmodel.finishModule { handler in
                        self?.dismissViewControllerAnimated(true, completion: handler)
                    }
                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
                default:
                    break
                }
            }
            .addDisposableTo(disposeBag)
        
    }
    
    // MARK: - Bindings
    func bindToViewModel(inputViewModel: InputViewModel) {
        self.inputViewModel = inputViewModel
        
    }
    
    // MARK: - Others
}