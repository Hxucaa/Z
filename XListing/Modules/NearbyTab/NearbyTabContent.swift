////
////  NearbyTabContent.swift
////  XListing
////
////  Created by Lance Zhu on 2015-08-31.
////  Copyright (c) 2016 Lance Zhu. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//public final class NearbyTabContent : ITabContent, NearbyNavigationControllerDelegate {
//    
//    private let nearbyTabNavigationController: NearbyTabNavigationController
//    public var navigationController: UINavigationController {
//        return nearbyTabNavigationController
//    }
//    
//    private let nearbyWireframe: INearbyWireframe
//    private let socialBusinessWireframe: ISocialBusinessWireframe
//    
//    public init(nearbyWireframe: INearbyWireframe, socialBusinessWireframe: ISocialBusinessWireframe) {
//        nearbyTabNavigationController = NearbyTabNavigationController(rootViewController: nearbyWireframe.rootViewController)
//        
//        self.nearbyWireframe = nearbyWireframe
//        self.socialBusinessWireframe = socialBusinessWireframe
//        
//        nearbyWireframe.navigationControllerDelegate = self
//    }
//    
//    public func pushSocialBusiness<T : Business>(business: T) {
//        socialBusinessWireframe.sharedNavigationController = nearbyTabNavigationController
//        nearbyTabNavigationController.pushViewController(socialBusinessWireframe.viewController(business), animated: true)
//    }
//}
