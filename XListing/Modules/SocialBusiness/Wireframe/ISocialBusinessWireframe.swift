//
//  ISocialBusinessWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol ISocialBusinessWireframe : class {
    init(rootWireframe: IRootWireframe, router: IRouter, userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService)
}