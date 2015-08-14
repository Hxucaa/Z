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
        println(navigationController.viewControllers)
//        println(navigationControoler.set)
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public func presentViewController<T: UIViewController>(viewController: T, animated: Bool, completion: (() -> ())? = nil) {
        navigationController.presentViewController(viewController, animated: animated, completion: completion)
    }
    
//    public func setViewControllers
}