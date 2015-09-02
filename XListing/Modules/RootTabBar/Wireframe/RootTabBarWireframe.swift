//
//  RootTabBarWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

public final class RootTabBarWireframe : IRootTabBarWireframe {

    private let rootTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootTabBarController") as! RootTabBarController
    public var rootViewController: UIViewController {
        return rootTabBarController
    }

    public required init(inWindow: UIWindow, userService: IUserService, accountWireframe: IAccountWireframe, featuredListTabItem: TabItem<FeaturedTabContent>, nearbyTabItem: TabItem<NearbyTabContent>, profileTabItem: TabItem<ProfileTabContent>) {
        
        rootTabBarController.setViewControllers([featuredListTabItem.rootNavigationController, nearbyTabItem.rootNavigationController, profileTabItem.rootNavigationController], animated: false)
        rootTabBarController.userService = userService
        rootTabBarController.accountWireframe = accountWireframe
    }
}

public final class RootTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    public weak var userService: IUserService!
    public weak var accountWireframe: IAccountWireframe!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    public func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController is ProfileTabNavigationController {
            // if user is logged in already, continue on
            if userService.isLoggedInAlready() {
                return true
            }
            // else make the user log in / sign up first
            else {
                accountWireframe.finishedCallback = { [weak self] in
                    if let this = self where this.userService.isLoggedInAlready() {
                        self?.selectedViewController = viewController
                    }
                }
                presentViewController(accountWireframe.rootViewController, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}
