//
//  ProfileTabContent.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public final class ProfileTabContent : ITabContent {
    
    private let profileTabNavigationController: ProfileTabNavigationController
    public var navigationController: UINavigationController {
        return profileTabNavigationController
    }
    
    private let profileWireframe: IProfileWireframe
    private let socialBusinessWireframe: ISocialBusinessWireframe
    private let profileEditWireframe: IProfileEditWireframe
    
    public init(profileWireframe: IProfileWireframe, socialBusinessWireframe: ISocialBusinessWireframe, profileEditWireframe: IProfileEditWireframe) {
        profileTabNavigationController = UIStoryboard(name: "ProfileTab", bundle: nil).instantiateViewControllerWithIdentifier("ProfileTabNavigationController") as! ProfileTabNavigationController
        profileTabNavigationController.viewControllers = [profileWireframe.rootViewController]
        
        self.profileWireframe = profileWireframe
        self.socialBusinessWireframe = socialBusinessWireframe
        self.profileEditWireframe = profileEditWireframe

        self.profileWireframe.navigationControllerDelegate = self
    }

}

extension ProfileTabContent : ProfileNavigationControllerDelegate {

    public func pushSocialBusiness<T : Business>(business: T, animated: Bool) {
        profileTabNavigationController.pushViewController(socialBusinessWireframe.viewController(business), animated: animated)
    }

    public func presentProfileEdit<T: User>(user: T, animated: Bool, completion: CompletionHandler?) {
        profileTabNavigationController.presentViewController(profileEditWireframe.viewController(user), animated: true, completion: completion)
    }
}