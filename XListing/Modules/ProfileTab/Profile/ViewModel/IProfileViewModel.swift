//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import ReactiveCocoa

public protocol IProfileViewModel : class {
    var profileBusinessViewModelArr: MutableProperty<[ProfileBusinessViewModel]> { get }
    var nickname: MutableProperty<String> { get }
    var profileHeaderViewModel: MutableProperty<ProfileHeaderViewModel?> { get }
    init(participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService)
    func pushSocialBusinessModule(section: Int, animated: Bool)
    func presentProfileEditModule(aniated: Bool, completion: CompletionHandler?)
    func undoParticipation(index: Int) -> SignalProducer<Bool, NSError>
}
