//
//  IRootWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IRootWireframe : class {
    func showRootViewController(viewController: UIViewController)
    func pushViewController(viewController: UIViewController, animated: Bool)
}