//
//  RootWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class RootWireframe : BaseWireframe {
    func showRootViewController(viewController: UIViewController, inWindow: UIWindow) {
        let navigationController = navigationControllerFromWindow(inWindow)
        navigationController.viewControllers = [viewController]
    }
    
    private func navigationControllerFromWindow(window: UIWindow) -> UINavigationController {
        let navigationController = window.rootViewController as UINavigationController
        return navigationController
    }
}