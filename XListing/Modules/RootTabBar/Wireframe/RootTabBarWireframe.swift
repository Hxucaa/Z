//
//  RootTabBarWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

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