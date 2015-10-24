//
//  ISocialBusiness_UserViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol ISocialBusiness_UserViewModel : class, IBasicUserInfoViewModel {
    
    // MARK: - Outputs
    var participationType: PropertyOf<String> { get }
    
    // MARK: - Initializers
    init(participationService: IParticipationService, imageService: IImageService, user: User, nickname: String?, ageGroup: AgeGroup?, horoscope: Horoscope?, gender: Gender, profileImage: ImageFile?, status: String?, participationType: ParticipationType)
}