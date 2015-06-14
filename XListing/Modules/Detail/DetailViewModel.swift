//
//  DetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit

public struct DetailViewModel : IDetailViewModel {
    
    // MARK: - Public
    
    // MARK: Outputs
    public let businessName: ConstantProperty<String>
    
    // MARK: ViewModels
    public let detailImageViewModel: DetailImageViewModel
    public let detailAddressAndMapViewModel: DetailAddressAndMapViewModel
    public let detailPhoneWebViewModel: DetailPhoneWebViewModel
    public let detailBizInfoViewModel: DetailBizInfoViewModel
    
    // MARK: Initializers
    public init(router: IRouter, userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, businessModel: Business) {
        self.router = router
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.business = businessModel
        
        detailImageViewModel = DetailImageViewModel(coverImageURL: business.cover?.url)
        detailAddressAndMapViewModel = DetailAddressAndMapViewModel(geoLocationService: geoLocationService, businessName: business.nameSChinese, address: business.address, city: business.city, state: business.state, businessLocation: business.cllocation)
        detailPhoneWebViewModel = DetailPhoneWebViewModel(businessName: business.nameSChinese, phone: business.phone, website: business.url)
        detailBizInfoViewModel = DetailBizInfoViewModel(userService: userService, participationService: participationService, geoLocationService: geoLocationService, business: businessModel)
        
        businessName = ConstantProperty(businessModel.nameSChinese!)
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let router: IRouter
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let business: Business
    
}