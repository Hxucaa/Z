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
    public var participationType: AnyProperty<String> {
        return AnyProperty(_participationType)
    }    
    
    // MARK: - Properties
    public let user: User
    private let imageService: IImageService
    private let participationService: IParticipationService

    
    // MARK: - Initializers
    public init(participationService: IParticipationService, imageService: IImageService, user: User, eventType: EventType) {
        self.participationService = participationService
        self.imageService = imageService
        
        self.user = user
        
        _participationType = MutableProperty(eventType.description)
        
        super.init(imageService: imageService, user: user)
    }
}
