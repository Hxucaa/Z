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

    private let rootTabBarController: RootTabBarController

    public required init(inWindow: UIWindow, featuredListTabItem: TabItem<FeaturedTabContent>, nearbyTabItem: TabItem<NearbyTabContent>, profileTabItem: TabItem<ProfileTabContent>) {
        rootTabBarController = inWindow.rootViewController as! RootTabBarController
        rootTabBarController.setViewControllers([featuredListTabItem.rootNavigationController, nearbyTabItem.rootNavigationController, profileTabItem.rootNavigationController], animated: false)
    }
}

public final class RootTabBarController : UITabBarController {

}