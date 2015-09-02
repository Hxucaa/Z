//
//  INearbyWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol INearbyWireframe : class, ITabRootWireframe {
    var navigationControllerDelegate: NearbyNavigationControllerDelegate! { get set }
    init(businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService)
}