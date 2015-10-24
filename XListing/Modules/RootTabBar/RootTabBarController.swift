//
//  RootTabBarController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public final class RootTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    public weak var userService: IUserService!
    public weak var accountWireframe: IAccountWireframe!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.x_PrimaryColor()
        tabBar.translucent = false
        delegate = self
    }
    
    public func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController is ProfileTabNavigationController {
            // if user is logged in already, continue on
            if userService.isLoggedInAlready() {
                return true
            }
                // else make the user log in / sign up first
            else {
                accountWireframe.finishedCallback = { [weak self] in
                    if let this = self where this.userService.isLoggedInAlready() {
                        self?.selectedViewController = viewController
                    }
                }
                presentViewController(accountWireframe.rootViewController, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}