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
    private let profileEditWireframe: IProfileEditWireframe
    
    public init(profileWireframe: IProfileWireframe, profileEditWireframe: IProfileEditWireframe) {
        profileTabNavigationController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("ProfileTabNavigationController") as! ProfileTabNavigationController
        profileTabNavigationController.viewControllers = [profileWireframe.rootViewController]
        
        self.profileWireframe = profileWireframe
        self.profileEditWireframe = profileEditWireframe
    }
}