//
//  AccountWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let AccountViewControllerIdentifier = "AccountViewController"

public class AccountWireframe : BaseWireframe {
    
    private let accountVM: IAccountViewModel
    private let rootWireframe: RootWireframe
    private var accountVC: AccountViewController?
    
    public init(rootWireframe: RootWireframe, accountVM: IAccountViewModel) {
        self.rootWireframe = rootWireframe
        self.accountVM = accountVM
    }
    
    public func pushAccountViewController() {
        let injectedViewController = injectViewModelToViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
    
    private func injectViewModelToViewController() -> AccountViewController {
        let viewController = getViewControllerFromStoryboard(AccountViewControllerIdentifier) as! AccountViewController
        viewController.accountVM = accountVM
        accountVC = viewController
        return viewController
    }
}