//
//  ISharedWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public protocol ISharedWireframe : class {
    var sharedNavigationController: UINavigationController? { get set }
}