//
//  BusinessDetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit

public final class BusinessDetailViewModel : IBusinessDetailViewModel {
    
    // MARK: - Public
    
    // MARK: - Outputs
    private let _businessName: ConstantProperty<String>
    public var businessName: PropertyOf<String> {
        return PropertyOf(_businessName)
    }
    
    // MARK: - Variables
    
    // MARK: Services
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let business: Business
    
    // MARK: ViewModels
    public let headerViewModel: SocialBusinessHeaderViewModel
//    public let detailImageViewModel: DetailImageViewModel
    public let detailAddressAndMapViewModel: DetailAddressAndMapViewModel
    public let detailPhoneWebViewModel: DetailPhoneWebViewModel
//    public let detailBizInfoViewModel: DetailBizInfoViewModel
    public let detailNavigationMapViewModel: DetailNavigationMapViewModel
//    public let detailParticipationViewModel: DetailParticipationViewModel
    public let businessHourViewModel: BusinessHourCellViewModel
    
    // MARK: Actions
    
    // MARK: Initializers
    public init(userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService, business: Business) {
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.business = business
        
        headerViewModel = SocialBusinessHeaderViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, cover: business.cover_, businessName: business.nameSChinese, city: business.city, geolocation: business.geolocation)
        
//        detailImageViewModel = DetailImageViewModel(imageService: imageService, coverImageURL: business.cover?.url)
        detailAddressAndMapViewModel = DetailAddressAndMapViewModel(geoLocationService: geoLocationService, businessName: business.nameSChinese, address: business.address, city: business.city, state: business.state, geolocation: business.geolocation)
        detailPhoneWebViewModel = DetailPhoneWebViewModel(businessName: business.nameSChinese, phone: business.phone, website: business.url)
//        detailBizInfoViewModel = DetailBizInfoViewModel(userService: userService, participationService: participationService, geoLocationService: geoLocationService, business: business)
        detailNavigationMapViewModel = DetailNavigationMapViewModel(geoLocationService: geoLocationService, businessName: business.nameSChinese, geolocation: business.geolocation)
//        detailParticipationViewModel = DetailParticipationViewModel(participationCount: business.wantToGoCounter)
        businessHourViewModel = BusinessHourCellViewModel()
        
        _businessName = ConstantProperty(business.nameSChinese!)
    }
    
    
}