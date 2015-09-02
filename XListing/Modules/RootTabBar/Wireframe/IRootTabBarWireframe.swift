//
//  IRootTabBarWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public protocol IRootTabBarWireframe : class, ITabRootWireframe {
    init(inWindow: UIWindow, userService: IUserService, accountWireframe: IAccountWireframe, featuredListTabItem: TabItem<FeaturedTabContent>, nearbyTabItem: TabItem<NearbyTabContent>, profileTabItem: TabItem<ProfileTabContent>)
}