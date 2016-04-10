//
//  BusinessDetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import RxSwift
import RxCocoa
import MapKit

final class BusinessDetailViewModel : IBusinessDetailViewModel, ViewModelInjectable {
    
    // MARK: - Public
    
    // MARK: - Outputs
    
    var businessImageURL: NSURL? {
        return business.coverImageUrl
    }
    
    var city: String {
        return business.city
    }
    
    let businessName: ConstantProperty<String>
    let webSiteURL: ConstantProperty<NSURL?>
    
    func calculateEta() -> Driver<String> {
        return geoLocationService.calculateETA(business.geolocation)
            .map { "\($0)分钟" }
            .asDriver(onErrorJustReturn: "")
    }
    
    // MARK: - Variables
    private let business: BusinessInfo
    
    // MARK: Services
    private let meRepository: IMeRepository
    private let geoLocationService: IGeoLocationService
    
    // MARK: ViewModels
//    let headerViewModel: SocialBusinessHeaderViewModel
    let descriptionViewModel: DescriptionCellViewModel
    let detailAddressAndMapViewModel: DetailAddressAndMapViewModel
    let detailPhoneWebViewModel: DetailPhoneWebViewModel
    let detailNavigationMapViewModel: DetailNavigationMapViewModel
    let businessHourViewModel: BusinessHourCellViewModel
    
    // MARK: Actions
    
    func callPhone() -> SignalProducer<Bool, NoError> {
        return SignalProducer(value: NSURL(string: "telprompt://\(business.phone)"))
            .ignoreNil()
            .map {
                UIApplication.sharedApplication().openURL($0)
            }
    }
    
    // MARK: Initializers
    typealias Dependency = (router: IRouter, meRepository: IMeRepository, businessRepository: IBusinessRepository, geoLocationService: IGeoLocationService)
    
    typealias Token = (BusinessInfo)
    
    typealias Input = Void
    
    init(dep: Dependency, token: Token, input: Input) {
        self.meRepository = dep.meRepository
        self.geoLocationService = dep.geoLocationService
        self.business = token
        
//        headerViewModel = SocialBusinessHeaderViewModel(geoLocationService: geoLocationService, imageService: imageService, coverImage: business.coverImage, name: business.name, city: business.address.city, geolocation: business.address.geoLocation)
        
        descriptionViewModel = DescriptionCellViewModel(description: token.description)
        
        detailAddressAndMapViewModel = DetailAddressAndMapViewModel(geoLocationService: geoLocationService, name: token.name, street: token.street, city: token.city, province: token.province, geolocation: token.geolocation)
        detailPhoneWebViewModel = DetailPhoneWebViewModel(name: token.name, phone: token.phone, website: token.websiteUrl)
        detailNavigationMapViewModel = DetailNavigationMapViewModel(geoLocationService: geoLocationService, name: token.name, geolocation: token.geolocation)
        businessHourViewModel = BusinessHourCellViewModel()
        
        businessName = ConstantProperty(token.name)
        webSiteURL = ConstantProperty(token.coverImageUrl)
    }
    
}