//
//  SocialBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public final class SocialBusinessViewModel : ISocialBusinessViewModel {
    
    
    // MARK: Services
    private let router: IRouter
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let business: Business
    
    // MARK: Initializers
    public init(router: IRouter, userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService, businessModel: Business) {
        self.router = router
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.business = businessModel
        
    }
}