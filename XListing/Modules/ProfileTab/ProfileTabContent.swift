////
////  ProfileTabContent.swift
////  XListing
////
////  Created by Lance Zhu on 2015-08-31.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//public final class ProfileTabContent : ITabContent {
//    
//    private let profileTabNavigationController: ProfileTabNavigationController
//    public var navigationController: UINavigationController {
//        return profileTabNavigationController
//    }
//    
//    private let profileWireframe: IProfileWireframe
//    private let socialBusinessWireframe: ISocialBusinessWireframe
//    private let profileEditWireframe: IProfileEditWireframe
//    private let fullScreenImageWireframe: IFullScreenImageWireframe
//    
//    public init(profileWireframe: IProfileWireframe, socialBusinessWireframe: ISocialBusinessWireframe, profileEditWireframe: IProfileEditWireframe, fullScreenImageWireframe: IFullScreenImageWireframe) {
//        profileTabNavigationController = ProfileTabNavigationController(rootViewController: profileWireframe.rootViewController)
//        
//        self.profileWireframe = profileWireframe
//        self.socialBusinessWireframe = socialBusinessWireframe
//        self.profileEditWireframe = profileEditWireframe
//        self.fullScreenImageWireframe = fullScreenImageWireframe
//        self.profileWireframe.navigationControllerDelegate = self
//    }
//
//}
//
//extension ProfileTabContent : ProfileNavigationControllerDelegate {
//
//    public func pushSocialBusiness<T : Business>(business: T, animated: Bool) {
//        socialBusinessWireframe.sharedNavigationController = profileTabNavigationController
//        profileTabNavigationController.pushViewController(socialBusinessWireframe.viewController(business), animated: animated)
//    }
//
//        public func presentProfileEdit(animated: Bool, completion: CompletionHandler?) {
//        profileTabNavigationController.presentViewController(profileEditWireframe.viewController(), animated: true, completion: completion)
//    }
//    
//    public func presentFullScreenImage(animated: Bool, completion: CompletionHandler?) {
//        profileTabNavigationController.presentViewController(fullScreenImageWireframe.viewController(), animated: true, completion: completion)
//    }
//}