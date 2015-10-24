//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import ReactiveCocoa

public protocol IProfileViewModel : class {
    
    // MARK: - Outputs
    
    // MARK: - Properties
    
    // MARK: ViewModels
    var profileUpperViewModel: IProfileUpperViewModel { get }
    var profileBottomViewModel: IProfileBottomViewModel { get }
    
    // MARK: - Initializers
    init(participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService)
    
    // MARK: - API
    func pushSocialBusinessModule(section: Int, animated: Bool)
    func presentProfileEditModule(aniated: Bool, completion: CompletionHandler?)
    func presentFullScreenImageModule(animated: Bool, completion: CompletionHandler?)
}
