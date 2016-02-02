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
    public let businessName: ConstantProperty<String>
    public let webSiteURL: ConstantProperty<NSURL?>
    
    // MARK: - Variables
    private let business: Business
    
    // MARK: Services
    private let meService: IMeService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    // MARK: ViewModels
    public let headerViewModel: SocialBusinessHeaderViewModel
    public let descriptionViewModel: DescriptionCellViewModel
    public let detailAddressAndMapViewModel: DetailAddressAndMapViewModel
    public let detailPhoneWebViewModel: DetailPhoneWebViewModel
    public let detailNavigationMapViewModel: DetailNavigationMapViewModel
    public let businessHourViewModel: BusinessHourCellViewModel
    
    // MARK: Actions
    
    public func callPhone() -> SignalProducer<Bool, NoError> {
        return SignalProducer(value: NSURL(string: "telprompt://\(business.phone)"))
            .ignoreNil()
            .map {
                UIApplication.sharedApplication().openURL($0)
            }
    }
    
    // MARK: Initializers
    public init(meService: IMeService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService, business: Business) {
        self.meService = meService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.business = business
        
        headerViewModel = SocialBusinessHeaderViewModel(geoLocationService: geoLocationService, imageService: imageService, coverImage: business.coverImage, name: business.name, city: business.address.city, geolocation: business.address.geoLocation)
        
        descriptionViewModel = DescriptionCellViewModel(description: business.descript)
        
        detailAddressAndMapViewModel = DetailAddressAndMapViewModel(geoLocationService: geoLocationService, name: business.name, street: business.address.street, city: business.address.city, province: business.address.province, geolocation: business.address.geoLocation)
        detailPhoneWebViewModel = DetailPhoneWebViewModel(name: business.name, phone: business.phone, website: business.websiteUrl)
        detailNavigationMapViewModel = DetailNavigationMapViewModel(geoLocationService: geoLocationService, name: business.name, geolocation: business.address.geoLocation)
        businessHourViewModel = BusinessHourCellViewModel()
        
        businessName = ConstantProperty(business.name)
        if let website = business.websiteUrl {
            webSiteURL = ConstantProperty(NSURL(string: website))
        }
        else {
            webSiteURL = ConstantProperty(nil)
        }
    }
    
}