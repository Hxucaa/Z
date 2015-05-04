//
//  NearbyViewControllerNavigationDelegate.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol NearbyViewControllerNavigationDelegate : class {
    func pushDetail(businessViewModel: BusinessViewModel)
}