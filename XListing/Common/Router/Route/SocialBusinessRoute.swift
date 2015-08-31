//
//  SocialBusinessRoute.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol SocialBusinessRoute : WithDataRoute {
    func pushWithData<T: Business>(business: T)
}