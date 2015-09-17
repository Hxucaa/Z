//
//  FeaturedListTabContent.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public final class FeaturedTabContent : ITabContent {
    
    private let featuredTabNavigationController: FeaturedTabNavigationController
    public var navigationController: UINavigationController {
        return featuredTabNavigationController
    }
    
    private let featuredListWireframe: IFeaturedListWireframe
    private let socialBusinessWireframe: ISocialBusinessWireframe
    
    public init(featuredListWireframe: IFeaturedListWireframe, socialBusinessWireframe: ISocialBusinessWireframe) {
        featuredTabNavigationController = FeaturedTabNavigationController(rootViewController: featuredListWireframe.rootViewController)
        
        self.featuredListWireframe = featuredListWireframe
        self.socialBusinessWireframe = socialBusinessWireframe
        
        self.featuredListWireframe.navigationControllerDelegate = self
    }

}

extension FeaturedTabContent : FeaturedListNavigationControllerDelegate {

    public func pushSocialBusiness<T : Business>(business: T) {
        socialBusinessWireframe.sharedNavigationController = featuredTabNavigationController
        featuredTabNavigationController.pushViewController(socialBusinessWireframe.viewController(business), animated: true)
    }
}