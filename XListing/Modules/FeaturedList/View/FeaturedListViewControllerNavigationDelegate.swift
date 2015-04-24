//
//  FeaturedListViewControllerNavigationDelegate.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol FeaturedListViewControllerNavigationDelegate : class {
    /// Push NearbyViewController to NavigationController
    func pushNearby()
    /// Push DetailViewController to NavigationController
    func pushDetail(businessViewModel: BusinessViewModel)
}