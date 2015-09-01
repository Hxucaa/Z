//
//  IFeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IFeaturedListWireframe : class, ITabRootWireframe {
    var navigationControllerDelegate: FeaturedListNavigationControllerDelegate! { get set }
    init(businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService)
}