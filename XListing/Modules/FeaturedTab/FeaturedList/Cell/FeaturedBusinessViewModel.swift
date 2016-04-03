//
//  FeaturedBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

//import Foundation
//import ReactiveCocoa

//public final class FeaturedBusinessViewModel : BasicBusinessInfoViewModel, IFeaturedBusinessViewModel {
//    
//    // MARK: - Outputs
//    
//    
//    // MARK: - Properties
//    private let userService: IUserService
//    private let geoLocationService: IGeoLocationService
//    private let imageService: IImageService
//    private let participationService: IParticipationService
//    public let business: Business
//    
//    // MARK: - Initializers
//    public init(userService: IUserService, geoLocationService: IGeoLocationService, imageService: IImageService, participationService: IParticipationService, business: Business) {
//        
//        self.userService = userService
//        self.geoLocationService = geoLocationService
//        self.imageService = imageService
//        self.participationService = participationService
//        
//        self.business = business
//        
//        super.init(geoLocationService: geoLocationService, imageService: imageService, business: business)
//    }
//
//    
//    // MARK: - Setups
//    
//    // MARK: - API
//    
//}

struct BusinessInfo {
    let name: String
    let phone: String
    let email: String?
    let websiteUrl: NSURL?
    let district: String
    let city: String
    let province: String
    let coverImageUrl: NSURL?
    let description: String?
    let averagePrice: String
    let aaCount: Int
    let treatCount: Int
    let toGoCount: Int
    let geolocation: CLLocation
    
    let business: Business
    
    init(business: Business) {
        name = business.name
        phone = business.phone
        email = business.email
        websiteUrl = business.websiteUrl
        district = business.address.district.regionNameC
        city = business.address.city.regionNameC
        province = business.address.province.regionNameC
        coverImageUrl = business.coverImage.url
        description = business.descriptor
        averagePrice = "30"
        aaCount = business.aaCount
        treatCount = business.treatCount
        toGoCount = business.toGoCount
        geolocation = business.address.geoLocation.cllocation
        
        self.business = business
    }
}