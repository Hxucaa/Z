//
//  IFeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IFeaturedListWireframe {
    var nearbyInterfaceDelegate: FeaturedListInterfaceToNearbyInterfaceDelegate? { get set }
    var detailInterfaceDelegate: FeaturedListInterfaceToDetailInterfaceDelegate? { get set }
    func showFeaturedListAsRootViewController()
}