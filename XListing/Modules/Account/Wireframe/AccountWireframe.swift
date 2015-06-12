//
//  AccountWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let AccountViewControllerIdentifier = "AccountViewController"
private let AccountStoryboardName = "Account"

public final class AccountWireframe : BaseWireframe, IAccountWireframe {
    
    private let router: IRouter
    private let userService: IUserService
    private var accountVC: AccountViewController?
    private var dismissCallback: CompletionHandler?
    
    public required init(rootWireframe: IRootWireframe, router: IRouter, userService: IUserService) {
        self.router = router
        self.userService = userService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    private func injectViewModelToViewController() -> AccountViewController {
        let viewController = getViewControllerFromStoryboard(AccountViewControllerIdentifier, storyboardName: AccountStoryboardName) as! AccountViewController
        let viewmodel = AccountViewModel(userService: userService, router: router)
        viewController.bindToViewModel(viewmodel, dismissCallback: dismissCallback)
        accountVC = viewController
        return viewController
    }
}

extension AccountWireframe : AccountRoute {
    public func push() {
        let injectedViewController = injectViewModelToViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
    
    public func present(completion: CompletionHandler?, dismissCallback: CompletionHandler?) {
        self.dismissCallback = dismissCallback
        let injectedViewController = injectViewModelToViewController()
        rootWireframe.presentViewController(injectedViewController, animated: true, completion: completion)
    }
}