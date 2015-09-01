//
//  NearbyTabContent.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public final class NearbyTabContent : ITabContent, NearbyNavigationControllerDelegate {
    
    private let nearbyTabNavigationController: NearbyTabNavigationController
    public var navigationController: UINavigationController {
        return nearbyTabNavigationController
    }
    
    private let nearbyWireframe: INearbyWireframe
    private let socialBusinessWireframe: ISocialBusinessWireframe
    
    public init(nearbyWireframe: INearbyWireframe, socialBusinessWireframe: ISocialBusinessWireframe) {
        nearbyTabNavigationController = UIStoryboard(name: "Nearby", bundle: nil).instantiateViewControllerWithIdentifier("NearbyTabNavigationController") as! NearbyTabNavigationController
        nearbyTabNavigationController.viewControllers = [nearbyWireframe.rootViewController]
        
        self.nearbyWireframe = nearbyWireframe
        self.socialBusinessWireframe = socialBusinessWireframe
        
        nearbyWireframe.navigationControllerDelegate = self
    }
    
    public func pushSocialBusiness<T : Business>(business: T) {
        nearbyTabNavigationController.pushViewController(socialBusinessWireframe.viewController(business), animated: true)
    }
}
