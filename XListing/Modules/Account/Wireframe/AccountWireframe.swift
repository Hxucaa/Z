//
//  AccountWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit
import UIKit

private let AccountViewControllerIdentifier = "AccountViewController"
private let SignUpViewControllerIdentifier = "SignUpViewController"

public class AccountWireframe : BaseWireframe, IAccountWireframe {
    
    private let navigator: INavigator
    private let accountVM: IAccountViewModel
    private var accountVC: AccountViewController?
    private var signUpVC: SignUpViewController?
    
    public init(rootWireframe: IRootWireframe, navigator: INavigator, accountVM: IAccountViewModel) {
        self.navigator = navigator
        self.accountVM = accountVM
        
        super.init(rootWireframe: rootWireframe)
        
        navigator.accountModuleNavigationNotificationSignal! ~> { notification -> Void in
            self.pushView()
            self.pushSignUpView()
        }
    }
    
    private func injectViewModelToViewController() -> AccountViewController {
        let viewController = getViewControllerFromStoryboard(AccountViewControllerIdentifier) as! AccountViewController
        viewController.accountVM = accountVM
        accountVC = viewController
        return viewController
    }
    
    
    private func pushView() {
        let injectedViewController = injectViewModelToViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
    
    private func injectViewModelToSignUpViewController() -> SignUpViewController {
        let viewController = getViewControllerFromStoryboard(SignUpViewControllerIdentifier) as! SignUpViewController
        viewController.accountVM = accountVM
        signUpVC = viewController
        return viewController    }
    
    
    private func pushSignUpView() {
        let injectedViewController = injectViewModelToSignUpViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}