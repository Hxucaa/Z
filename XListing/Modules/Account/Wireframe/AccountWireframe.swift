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
    
    private let accountVM: IAccountViewModel
    private var accountVC: AccountViewController?
    
    private let navigationNotificationReceiver: Stream<NSNotification?>
    
    public init(rootWireframe: IRootWireframe, accountVM: IAccountViewModel) {
        self.accountVM = accountVM
        
        navigationNotificationReceiver = Notification.stream(NavigationNotificationName.PushAccountModule, nil)
        
        super.init(rootWireframe: rootWireframe)
        
        navigationNotificationReceiver ~> { notification -> Void in
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