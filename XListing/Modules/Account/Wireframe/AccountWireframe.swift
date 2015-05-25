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

public class AccountWireframe : BaseWireframe, IAccountWireframe {
    
    private let navigator: INavigator
    private let accountVM: IAccountViewModel
    private var accountVC: AccountViewController?
    
    public init(rootWireframe: IRootWireframe, navigator: INavigator, accountVM: IAccountViewModel) {
        self.navigator = navigator
        self.accountVM = accountVM
        
        super.init(rootWireframe: rootWireframe)
        
        navigator.accountModuleNavigationNotificationSignal! ~> { notification -> Void in
            self.pushView()
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
}