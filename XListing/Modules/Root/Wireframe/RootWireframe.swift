//
//  RootWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class RootWireframe : BaseWireframe {
    
    private let navigationController: UINavigationController
    
    init(inWindow: UIWindow) {
        navigationController = inWindow.rootViewController as! UINavigationController
    }
    
    public func showRootViewController(viewController: UIViewController) {
        navigationController.viewControllers = [viewController]
    }
    
    public func pushViewController(viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }
}