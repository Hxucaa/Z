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
    public var businessName: AnyProperty<String> {
        return AnyProperty(_businessName)
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
        
        headerViewModel = SocialBusinessHeaderViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, coverImage: business.coverImage, name: business.name, city: business.address.city, geolocation: business.address.geoLocation)
        
//        detailImageViewModel = DetailImageViewModel(imageService: imageService, coverImageURL: business.cover?.url)
        detailAddressAndMapViewModel = DetailAddressAndMapViewModel(geoLocationService: geoLocationService, name: business.name, street: business.address.street, city: business.address.city, province: business.address.province, geolocation: business.address.geoLocation)
        detailPhoneWebViewModel = DetailPhoneWebViewModel(name: business.name, phone: business.phone, website: business.websiteUrl)
//        detailBizInfoViewModel = DetailBizInfoViewModel(userService: userService, participationService: participationService, geoLocationService: geoLocationService, business: business)
        detailNavigationMapViewModel = DetailNavigationMapViewModel(geoLocationService: geoLocationService, name: business.name, geolocation: business.address.geoLocation)
//        detailParticipationViewModel = DetailParticipationViewModel(participationCount: business.wantToGoCounter)
        businessHourViewModel = BusinessHourCellViewModel()
        
        _businessName = ConstantProperty(business.name)
    }
    
    
}