//
//  ChatTabContent.swift
//  XListing
//
//  Created by Hong Zhu on 2016-02-28.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit

//public final class ChatTabContent : ITabContent {
//    
//    private let featuredTabNavigationController: FeaturedTabNavigationController
//    public var navigationController: UINavigationController {
//        return featuredTabNavigationController
//    }
//    
//    private let chatWireframe: IChatListWireframe
//    private let socialBusinessWireframe: ISocialBusinessWireframe
//    
//    public init(chatListWireframe: IChatListWireframe) {
//        featuredTabNavigationController = FeaturedTabNavigationController(rootViewController: featuredListWireframe.rootViewController)
//        
//        self.featuredListWireframe = featuredListWireframe
//        self.socialBusinessWireframe = socialBusinessWireframe
//        
//        self.featuredListWireframe.navigationControllerDelegate = self
//    }
//    
//}
//
//extension ChatTabContent : FeaturedListNavigationControllerDelegate {
//    
//    public func pushSocialBusiness<T : Business>(business: T) {
//        socialBusinessWireframe.sharedNavigationController = featuredTabNavigationController
//        featuredTabNavigationController.pushViewController(socialBusinessWireframe.viewController(business), animated: true)
//    }
//}