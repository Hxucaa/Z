//
//  IRootWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public protocol IRootWireframe : class {
    func showRootViewController<T: UIViewController>(viewController: T)
    func pushViewController<T: UIViewController>(viewController: T, animated: Bool)
    func presentViewController<T: UIViewController>(viewController: T, animated: Bool, completion: (() -> ())?)
}