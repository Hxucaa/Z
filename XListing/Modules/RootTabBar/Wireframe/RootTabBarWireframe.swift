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

    private let rootTabBarController = RootTabBarController()
    public var rootViewController: UIViewController {
        return rootTabBarController
    }

    public required init(inWindow: UIWindow, meService: IMeService, accountWireframe: IAccountWireframe, featuredListTabItem: TabItem<FeaturedTabContent>, nearbyTabItem: TabItem<NearbyTabContent>, profileTabItem: TabItem<ProfileTabContent>) {
        
        rootTabBarController.setViewControllers([featuredListTabItem.rootNavigationController, nearbyTabItem.rootNavigationController, profileTabItem.rootNavigationController], animated: false)
        rootTabBarController.meService = meService
        rootTabBarController.accountWireframe = accountWireframe
    }
}