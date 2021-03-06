//
//  FeaturedBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class FeaturedBusinessViewModel : BasicBusinessInfoViewModel, IFeaturedBusinessViewModel {
    
    // MARK: - Outputs
    
    
    // MARK: - Properties
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let participationService: IParticipationService
    public let business: Business
    
    // MARK: - Initializers
    public init(userService: IUserService, geoLocationService: IGeoLocationService, imageService: IImageService, participationService: IParticipationService, business: Business) {
        
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.participationService = participationService
        
        self.business = business
        
        super.init(geoLocationService: geoLocationService, imageService: imageService, business: business)
    }

    
    // MARK: - Setups
    
    // MARK: - API
    
}