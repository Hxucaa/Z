//
//  RootTabBarController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-01.
//  Copyright © 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

final class RootTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    
    var selectedViewControllerCallback: (UIViewController -> ())?
    var meRepository: IMeRepository!
    weak var router: IRouter!
    
    private weak var activeNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.x_PrimaryColor()
        tabBar.translucent = false
        delegate = self
        
        DynamicProperty(object: self, keyPath: "selectedViewController").producer
            .ignoreNil()
            .map { $0 as! UIViewController }
            .startWithNext { [unowned self] in
                if let f = self.selectedViewControllerCallback {
                    f($0)
                }
            }
        
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        if viewController is ProfileTabNavigationController {
//            // if user is logged in already, continue on
//            if let me = meRepository.me() {
//                return true
//            }
//                // else make the user log in / sign up first
//            else {
//                router.accountFinishedCallback = { [weak self] in
//                    if let me = meRepository.me() {
//                        self?.selectedViewController = viewController
//                    }
//                }
//                presentViewController(accountWireframe.rootViewController, animated: true, completion: nil)
//                return false
//            }
//        }
        if let nav = viewController as? FeaturedTabNavigationController {
            activeNavigationController = nav
            return true
        }
        
        return true
    }
}
