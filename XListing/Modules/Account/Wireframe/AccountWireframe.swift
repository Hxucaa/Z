//
//  AccountWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let AccountViewControllerIdentifier = "AccountViewController"

public class AccountWireframe : BaseWireframe, IAccountWireframe {
    
    private let accountVM: IAccountViewModel
    private let rootWireframe: RootWireframe
    private var accountVC: AccountViewController?
    
    public init(rootWireframe: RootWireframe, accountVM: IAccountViewModel) {
        self.rootWireframe = rootWireframe
        self.accountVM = accountVM
    }
    
    private func injectViewModelToViewController() -> AccountViewController {
        let viewController = getViewControllerFromStoryboard(AccountViewControllerIdentifier) as! AccountViewController
        viewController.accountVM = accountVM
        accountVC = viewController
        return viewController
    }
}

extension AccountWireframe : AccountInterfaceDelegate {
    public func pushInterface() {
        let injectedViewController = injectViewModelToViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}