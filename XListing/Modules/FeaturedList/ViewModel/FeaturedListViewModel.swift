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

private let 启动无限scrolling参数 = 0.7
private let PaginationLimit = 20

public final class FeaturedListViewModel : IFeaturedListViewModel {
    
    // MARK: - Public
    
    // MARK: Input
    
    // MARK: Output
    public let featuredBusinessViewModelArr: MutableProperty<[FeaturedBusinessViewModel]> = MutableProperty([FeaturedBusinessViewModel]())
    public let isFetchingData: MutableProperty<Bool> = MutableProperty(false)
    
    // MARK: Private Variables
    
    // MARK: API
    
    /**
    Retrieve featured business from database
    */
    public func getFeaturedBusinesses() -> SignalProducer<[FeaturedBusinessViewModel], NSError> {
        let query = Business.query()!
        // TODO: temporarily disabled until we have more featured businesses
//        query.whereKey(Business.Property.Featured.rawValue, equalTo: true)
        query.limit = PaginationLimit
        query.skip = loadedBusinesses.value
        
        return SignalProducer<[Business], NSError>.empty
            |> on(completed: { [weak self] in
                self?.isFetchingData.put(true)
            })
            |> then(businessService.findBy(query))
            |> on(next: { businesses in
                
                // increment loaded businesses counter
                self.loadedBusinesses.put(businesses.count + self.loadedBusinesses.value)
                
                // save the business models
                self.businessArr.put(self.businessArr.value + businesses)
            })
            |> map { businesses -> [FeaturedBusinessViewModel] in
                
                // map the business models to viewmodels
                return businesses.map {
                    FeaturedBusinessViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: $0.nameSChinese, city: $0.city, district: $0.district, cover: $0.cover, geopoint: $0.geopoint, participationCount: $0.wantToGoCounter)
                }
            }
            |> on(event: { [weak self] event in
                self?.isFetchingData.put(false)
            })
            |> on(
                next: { response in
                    self.featuredBusinessViewModelArr.put(self.featuredBusinessViewModelArr.value + response)
                },
                error: { FeaturedLogError($0.description) }
            )
    }
    
    /**
    Return a boolean value indicating whether there are still plenty of data for display.
    
    :param: index The index of the currently displaying Business.
    
    :returns: A Boolean value.
    */
    public func havePlentyOfData(index: Int) -> Bool {
        return Double(index % PaginationLimit) > ceil(Double(PaginationLimit) * 启动无限scrolling参数)
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
    private let businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
    private var loadedBusinesses: MutableProperty<Int> = MutableProperty(0)
}