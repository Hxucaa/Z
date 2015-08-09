//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import ReactiveCocoa

public protocol IProfileViewModel : class {
    init(router: IRouter, participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService)
    var nickname: MutableProperty<String> { get }
    var profileEditViewModel: ProfileEditViewModel { get }
    func pushDetailModule(section: Int)
}
