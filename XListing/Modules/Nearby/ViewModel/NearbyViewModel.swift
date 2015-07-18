//
//  NearbyViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit
import AVOSCloud

public struct NearbyViewModel : INearbyViewModel {
    
    // MARK: - Public
    // MARK: Input
    
    // MARK: Output
    public let businessViewModelArr: MutableProperty<[NearbyTableCellViewModel]> = MutableProperty([NearbyTableCellViewModel]())
    public let fetchingData: MutableProperty<Bool> = MutableProperty(false)
    
    // MARK: API
    
    /**
    Get current geo location. If location service fails for any reason, use hardcoded geo location instead.
    
    :returns: A Task that contains a geo location.
    */
        public var currentLocation: SignalProducer<CLLocation, NSError> {
        return geoLocationService.getCurrentLocation()
            |> catch { error -> SignalProducer<CLLocation, NSError> in
                
                return SignalProducer { sink, disposable in
                    // with hardcoded location
                    //TODO: better support for hardcoded location
                    NearbyLogWarning("Location service failed! Using default Vancouver location.")
                    sendNext(sink, CLLocation(latitude: 49.27623, longitude: -123.12941))
                    sendCompleted(sink)
                }
        }
    }
    
    /**
    Navigate to Detail Module.
    
    :param: businessViewModel The business information to pass along.
    */
    public func pushDetailModule(section: Int) {
        router.pushDetail(businessArr.value[section])
    }
    
    public func pushProfileModule() {
        router.pushProfile()
    }
    
    // MARK: Initializers
    public init(router: IRouter, businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        self.router = router
        self.businessService = businessService
        self.geoLocationService = geoLocationService
        self.imageService = imageService

        getBusinesses()
            |> start()
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let router: IRouter
    private let businessService: IBusinessService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    private var businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
    
    private func getBusinesses() -> SignalProducer<[NearbyTableCellViewModel], NSError> {
        let query = Business.query()!
        
        // TODO: implement default location.
        return businessService.findBy(query)
            |> on(next: { businesses in
                self.fetchingData.put(true)
                self.businessArr.put(businesses)
            })
            |> map { businesses -> [NearbyTableCellViewModel] in
                return businesses.map {
                    NearbyTableCellViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: $0.nameSChinese, city: $0.city, district: $0.district, cover: $0.cover, geopoint: $0.geopoint)
                }
            }
            |> on(
                next: { response in
                    self.fetchingData.put(false)
                    self.businessViewModelArr.put(response)
                },
                error: { NearbyLogError($0.description) }
            )
    }

}