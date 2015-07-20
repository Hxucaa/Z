//
//  INearbyWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol INearbyWireframe : class {
    init(rootWireframe: IRootWireframe, router: IRouter, businessService: IBusinessService, geoLocationService: IGeoLocationService)
}