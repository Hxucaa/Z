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
import RxOptional
import MapKit

final class BusinessDetailViewModel : _BaseViewModel, IBusinessDetailViewModel, ViewModelInjectable {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    var businessName: String {
        return business.name
    }
    
    var phoneDisplay: String {
        return business.phone
    }
    
    var websiteDisplay: String {
        return business.websiteUrl != nil ? "访问网站" : "没有网站"
    }
    
    var businessImageURL: NSURL? {
        return business.coverImageUrl
    }
    
    var city: String {
        return business.city
    }
    
    var descriptor: String {
        return business.description ?? "这个地点还没有详细信息"
    }
    
    var fullAddress: String {
        return "\(business.street), \(business.city), \(business.province)"
    }
    
    var annotation: MKPointAnnotation {
        let location = business.geolocation.coordinate
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = businessName
        return annotation
    }
    
    var cellMapRegion: MKCoordinateRegion {
        let location = business.geolocation.coordinate

        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        return region
    }
    
    var webSiteURL: NSURL? {
        return business.websiteUrl
    }
    
    func calculateEta() -> Driver<String> {
        return geoLocationService.calculateETA(business.geolocation)
            .map { "\($0)分钟" }
            .asDriver(onErrorJustReturn: "")
    }
    
    let meAndBusinessRegion: Driver<MKCoordinateRegion>
    
    let callStatus: Observable<Bool>
    
    // MARK: - Variables
    private let business: BusinessInfo
    
    // MARK: Services
    private let meRepository: IMeRepository
    private let geoLocationService: IGeoLocationService
    
    // MARK: ViewModels
//    let headerViewModel: SocialBusinessHeaderViewModel
//    let descriptionViewModel: DescriptionCellViewModel
//    let detailAddressAndMapViewModel: DetailAddressAndMapViewModel
//    let detailPhoneWebViewModel: DetailPhoneWebViewModel
//    let detailNavigationMapViewModel: DetailNavigationMapViewModel
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
    
    typealias Input = (makeACall: Observable<Void>, dummy: Void)
    
    init(dep: Dependency, token: Token, input: Input) {
        self.meRepository = dep.meRepository
        self.geoLocationService = dep.geoLocationService
        self.business = token
        
//        headerViewModel = SocialBusinessHeaderViewModel(geoLocationService: geoLocationService, imageService: imageService, coverImage: business.coverImage, name: business.name, city: business.address.city, geolocation: business.address.geoLocation)
        
//        descriptionViewModel = DescriptionCellViewModel(description: token.description)
//        
//        detailAddressAndMapViewModel = DetailAddressAndMapViewModel(geoLocationService: geoLocationService, name: token.name, street: token.street, city: token.city, province: token.province, geolocation: token.geolocation)
//        detailPhoneWebViewModel = DetailPhoneWebViewModel(name: token.name, phone: token.phone, website: token.websiteUrl)
//        detailNavigationMapViewModel = DetailNavigationMapViewModel(geoLocationService: geoLocationService, name: token.name, geolocation: token.geolocation)
        businessHourViewModel = BusinessHourCellViewModel()
        
        meAndBusinessRegion = dep.geoLocationService.rx_getCurrentGeoPoint()
            .map { current -> MKCoordinateRegion in
                let distance = token.geolocation.distanceFromLocation(current)
                let spanFactor = distance / 45000.00
                let span = MKCoordinateSpanMake(spanFactor, spanFactor)
                let region = MKCoordinateRegion(center: token.geolocation.coordinate, span: span)
                return region
            }
            .asDriver { _ in Driver.empty() }
        
        callStatus = input.makeACall
            .map { NSURL(string: "telprompt://\(token.phone)") }
            .filterNil()
            .flatMap {
                Observable.just(UIApplication.sharedApplication().openURL($0))
            }
        
        
        
        super.init(router: dep.router)
    }
    
}