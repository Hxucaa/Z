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
    
    // MARK: - Outputs
    public let businessName: ConstantProperty<String>
    
    // MARK: ViewModels
    public let detailImageViewModel: DetailImageViewModel
    public let detailAddressAndMapViewModel: DetailAddressAndMapViewModel
    public let detailPhoneWebViewModel: DetailPhoneWebViewModel
    public let detailBizInfoViewModel: DetailBizInfoViewModel
    public let detailNavigationMapViewModel: DetailNavigationMapViewModel
    public let detailParticipationViewModel: DetailParticipationViewModel
    
    // MARK: Actions
    public func pushWantToGo() {
        router.pushWantToGo(business)
    }
    
    // MARK: Initializers
    public init(router: IRouter, userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService, businessModel: Business) {
        self.router = router
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.business = businessModel
        
        detailImageViewModel = DetailImageViewModel(imageService: imageService, coverImageURL: business.cover?.url)
        detailAddressAndMapViewModel = DetailAddressAndMapViewModel(geoLocationService: geoLocationService, businessName: business.nameSChinese, address: business.address, city: business.city, state: business.state, businessLocation: business.cllocation)
        detailPhoneWebViewModel = DetailPhoneWebViewModel(businessName: business.nameSChinese, phone: business.phone, website: business.url)
        detailBizInfoViewModel = DetailBizInfoViewModel(userService: userService, participationService: participationService, geoLocationService: geoLocationService, business: businessModel)
        detailNavigationMapViewModel = DetailNavigationMapViewModel(geoLocationService: geoLocationService, businessName: business.nameSChinese, businessLocation: business.cllocation)
        detailParticipationViewModel = DetailParticipationViewModel(participationCount: business.wantToGoCounter)

        
        businessName = ConstantProperty(businessModel.nameSChinese!)
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let router: IRouter
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let business: Business
    
}