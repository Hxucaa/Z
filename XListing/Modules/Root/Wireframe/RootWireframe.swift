//
//  RootWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public class RootWireframe : IRootWireframe {
    
    private let navigationController: UINavigationController
    
    public init(inWindow: UIWindow) {
        navigationController = inWindow.rootViewController as! UINavigationController
        navigationController.navigationBar.barStyle = UIBarStyle.Black
    }
    
    public func showRootViewController<T: UIViewController>(viewController: T) {
        navigationController.viewControllers = [viewController]
    }
    
    public func pushViewController<T: UIViewController>(viewController: T, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public func presentViewController<T: UIViewController>(viewController: T, animated: Bool, completion: (() -> ())? = nil) {
        navigationController.presentViewController(viewController, animated: animated, completion: completion)
    }
}

public final class RootTabControllerWireframe {

    private let rootTabBarController: RootTabBarController

    public init(inWindow: UIWindow, featuredListTabItem: TabItem<FeaturedListTabContent>, nearbyTabItem: TabItem<NearbyTabContent>, profileTabItem: TabItem<ProfileTabContent>) {
        rootTabBarController = inWindow.rootViewController as! RootTabBarController
        rootTabBarController.setViewControllers([featuredListTabItem.rootNavigationController, nearbyTabItem.rootNavigationController, profileTabItem.rootNavigationController], animated: false)
    }
}

public final class RootTabBarController : UITabBarController {

}

public final class TabItem<T: TabContent> {
    private let tabContent: T
    public var rootNavigationController: UINavigationController {
        return tabContent.navigationController
    }
    
    public init(tabContent: T) {
        self.tabContent = tabContent
    }
}

public protocol TabContent : class {
    var navigationController: UINavigationController { get }
}

public final class FeaturedListTabContent : TabContent {
    
    private let featuredListTabNavigationController: FeaturedListTabNavigationController
    public var navigationController: UINavigationController {
        return featuredListTabNavigationController
    }

    public init(featuredListWireframe: IFeaturedListWireframe) {
        featuredListTabNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FeaturedListTabNavigationController") as! FeaturedListTabNavigationController
        featuredListTabNavigationController.viewControllers = [featuredListWireframe.viewController]
    }
}

public final class FeaturedListTabNavigationController : UINavigationController {

}

public final class NearbyTabContent : TabContent {
    
    private let nearbyTabNavigationController: NearbyTabNavigationController
    public var navigationController: UINavigationController {
        return nearbyTabNavigationController
    }

    public init(nearbyWireframe: INearbyWireframe) {
        nearbyTabNavigationController = UIStoryboard(name: "Nearby", bundle: nil).instantiateViewControllerWithIdentifier("NearbyTabNavigationController") as! NearbyTabNavigationController
        nearbyTabNavigationController.viewControllers = [nearbyWireframe.viewController]
    }
}

public final class NearbyTabNavigationController : UINavigationController {
    
}

public final class ProfileTabContent : TabContent {

    private let profileTabNavigationController: ProfileTabNavigationController
    public var navigationController: UINavigationController {
        return profileTabNavigationController
    }

    public init(profileWireframe: IProfileWireframe) {
        profileTabNavigationController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("ProfileTabNavigationController") as! ProfileTabNavigationController
        profileTabNavigationController.viewControllers = [profileWireframe.viewController]
    }

}

public final class ProfileTabNavigationController : UINavigationController {

}
//
//public final class ProfileTab : TabContent {
//
//}

public protocol Wireframe : class {
    var viewController: UIViewController { get }
}