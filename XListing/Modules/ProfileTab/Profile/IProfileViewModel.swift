//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import ReactiveCocoa

public protocol IProfileViewModel : class {
    
    // MARK: - Outputs
    
    var profileBusinessViewModelArr: MutableProperty<[ProfileBusinessViewModel]> { get }
    
    // MARK: - Properties
    
    // MARK: ViewModels
    var profileHeaderViewModel: PropertyOf<ProfileHeaderViewModel?> { get }
    
    // MARK: - Initializers
    init(participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService)
    
    // MARK: - API
    func getUserInfo() -> SignalProducer<Void, NSError>
    func pushSocialBusinessModule(section: Int, animated: Bool)
    func presentProfileEditModule(aniated: Bool, completion: CompletionHandler?)
    func undoParticipation(index: Int) -> SignalProducer<Bool, NSError>
}
