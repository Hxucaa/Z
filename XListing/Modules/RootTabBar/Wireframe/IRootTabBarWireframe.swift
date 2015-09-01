//
//  IRootTabBarWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public protocol IRootTabBarWireframe : class {
    init(inWindow: UIWindow, featuredListTabItem: TabItem<FeaturedTabContent>, nearbyTabItem: TabItem<NearbyTabContent>, profileTabItem: TabItem<ProfileTabContent>)
}