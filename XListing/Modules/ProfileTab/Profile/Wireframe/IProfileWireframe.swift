//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IProfileWireframe : class, ITabRootWireframe {
    var navigationControllerDelegate: ProfileNavigationControllerDelegate! { get set }
    init(participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService)
}