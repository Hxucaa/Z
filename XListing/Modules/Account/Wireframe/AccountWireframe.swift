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
    private let userDefaultsService: IUserDefaultsService
    
    public required init(rootWireframe: IRootWireframe, router: IRouter, userService: IUserService, userDefaultsService: IUserDefaultsService) {
        self.router = router
        self.userService = userService
        self.userDefaultsService = userDefaultsService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    private func injectViewModelToViewController(dismissCallback: CompletionHandler? = nil) -> AccountViewController {
        let viewController = getViewControllerFromStoryboard(AccountViewControllerIdentifier, storyboardName: AccountStoryboardName) as! AccountViewController
        let viewmodel = AccountViewModel(userService: userService, router: router, userDefaultsService: userDefaultsService, dismissCallback: dismissCallback)
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

extension AccountWireframe : AccountRoute {
    public func push() {
        let injectedViewController = injectViewModelToViewController(dismissCallback: nil)
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
    
    public func present(completion: CompletionHandler?, dismissCallback: CompletionHandler?) {
        let injectedViewController = injectViewModelToViewController(dismissCallback: dismissCallback)
        rootWireframe.presentViewController(injectedViewController, animated: true, completion: completion)
    }
}