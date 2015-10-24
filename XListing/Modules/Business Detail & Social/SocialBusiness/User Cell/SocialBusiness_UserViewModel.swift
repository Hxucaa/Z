//
//  SocialBusiness_UserViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray
import Dollar
import AVOSCloud

public final class SocialBusiness_UserViewModel : BasicUserInfoViewModel, ISocialBusiness_UserViewModel {
    
    // MARK: - Outputs
    
    private let _participationType: MutableProperty<String>
    public var participationType: PropertyOf<String> {
        return PropertyOf(_participationType)
    }    
    
    // MARK: - Properties
    private let imageService: IImageService
    private let participationService: IParticipationService

    
    // MARK: - Initializers
    public init(participationService: IParticipationService, imageService: IImageService, user: User, nickname: String?, ageGroup: AgeGroup?, horoscope: Horoscope?, gender: Gender, profileImage: ImageFile?, status: String?, participationType: ParticipationType) {
        self.participationService = participationService
        self.imageService = imageService
        
        _participationType = MutableProperty(convertParticipationType(participationType))
        
        super.init(imageService: imageService, user: user, nickname: nickname, ageGroup: ageGroup, horoscope: horoscope, gender: gender, profileImage: profileImage, status: status)
    }
}
