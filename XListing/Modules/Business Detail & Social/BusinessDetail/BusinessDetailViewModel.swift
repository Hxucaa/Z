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
    
    let businessHour: String
    
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
        
        
        businessHour = "今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM"
        
        super.init(router: dep.router)
    }
}