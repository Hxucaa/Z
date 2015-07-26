//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import Dollar

public struct FeaturedListViewModel : IFeaturedListViewModel {
    
    // MARK: - Public
    
    // MARK: Input
    
    // MARK: Output
    public let featuredBusinessViewModelArr: MutableProperty<[FeaturedBusinessViewModel]> = MutableProperty([FeaturedBusinessViewModel]())
    public let fetchingData: MutableProperty<Bool> = MutableProperty(false)
    
    // MARK: Actions
    
    // MARK: API
    
    /**
    Retrieve featured business from database
    */
    public func getFeaturedBusinesses() -> SignalProducer<[FeaturedBusinessViewModel], NSError> {
        let query = Business.query()!
        query.whereKey(Business.Property.Featured.rawValue, equalTo: true)
        
        return businessService.findBy(query)
            |> on(next: { businesses in
                self.fetchingData.put(true)
            })
            |> map { businesses -> [FeaturedBusinessViewModel] in
                // shuffle and save the business models
                self.businessArr.put($.shuffle(businesses))
                
                // map the business models to viewmodels
                return self.businessArr.value.map {
                    FeaturedBusinessViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: $0.nameSChinese, city: $0.city, district: $0.district, cover: $0.cover, geopoint: $0.geopoint, participationCount: $0.wantToGoCounter)
                    }
            }
            |> on(
                next: { response in
                    self.fetchingData.put(false)
                    self.featuredBusinessViewModelArr.put(response)
                },
                error: { FeaturedLogError($0.description) }
            )
    }
    
    public func pushNearbyModule() {
        router.pushNearby()
    }
    
    public func pushDetailModule(section: Int) {
        router.pushDetail(businessArr.value[section])
    }
    
    public func pushProfileModule() {
        router.pushProfile()
    }
    
    // MARK: Initializers
    public init(router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService) {
        self.router = router
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService
        
        getFeaturedBusinesses()
            |> start()
    }
    
    // MARK: - Private
    
    // MARK: Private variables
    private let router: IRouter
    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    private var businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
}