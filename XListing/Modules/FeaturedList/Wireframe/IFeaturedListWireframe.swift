//
//  IFeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IFeaturedListWireframe {
    init(rootWireframe: IRootWireframe, navigator: INavigator, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService)
    func showFeaturedListAsRootViewController()
}