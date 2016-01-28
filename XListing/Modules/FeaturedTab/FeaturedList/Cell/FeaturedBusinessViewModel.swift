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
    public var props: SignalProducer<RNProps, NoError> {
        
        return combineLatest(
            name.producer,
            city.producer,
            coverImageUrl.producer,
            eta.producer,
            treatCount.producer,
            toGoCount.producer
            )
            .map { name, city, coverImageUrl, eta, treatCount, toGoCount in
                var props: RNProps = [
                    "businessName": name,
                    "location": city,
                    "coverImageUrl": coverImageUrl,
                    "treatCount": treatCount,
                    "toGoCount": toGoCount
                ]
                
                if let eta = eta {
                    props["eta"] = eta
                }
                
                return props
            }
    }
    
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