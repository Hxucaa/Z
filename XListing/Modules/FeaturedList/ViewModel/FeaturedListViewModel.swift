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
    
    // MARK: Private Variables
    private static var loadedBusinesses = 0
    
    // MARK: API
    
    /**
    Retrieve featured business from database
    */
    public func getFeaturedBusinesses() -> SignalProducer<[FeaturedBusinessViewModel], NSError> {
        let query = Business.query()!
        query.whereKey(Business.Property.Featured.rawValue, equalTo: true)
        query.limit = 7
        query.skip = self.loadedBusinesses.value
        
        return businessService.findBy(query)
            |> on(next: { businesses in
                self.fetchingData.put(true)
            })
            |> map { businesses -> [FeaturedBusinessViewModel] in
                // save the business models
                let gotBusinesses = businesses
                let arrayItems = self.businessArr.value.count
                self.businessArr.put(self.businessArr.value + businesses)
                
                // increment loaded businesses counter
                self.loadedBusinesses.put(businesses.count + self.loadedBusinesses.value)
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
        let debugArray = businessArr.value
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
    private var loadedBusinesses: MutableProperty<Int> = MutableProperty(0)
    private var businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
}