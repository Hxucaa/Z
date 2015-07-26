//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IProfileWireframe : class {
    init(rootWireframe: IRootWireframe, router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService)
}