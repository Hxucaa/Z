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

private let 启动无限scrolling参数 = 0.4

public final class FeaturedListViewModel : IFeaturedListViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    public let featuredBusinessViewModelArr: MutableProperty<[FeaturedBusinessViewModel]> = MutableProperty([FeaturedBusinessViewModel]())
    public let isFetchingData: MutableProperty<Bool> = MutableProperty(false)
    
    // MARK: - Properties
    // MARK: Services
    private let router: IRouter
    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    
    // MARK: Variables
    private let businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
    private var numberOfBusinessesLoaded = 0
    
    // MARK: Initializers
    public init(router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService) {
        self.router = router
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService
    }
    
    // MARK: - API
    
    /**
    Refresh the list of featured businesses. NOTE: the new list replaces the original one.
    */
    public func refreshFeaturedBusinesses() -> SignalProducer<[FeaturedBusinessViewModel], NSError> {
        return fetchBusinesses(refresh: true)
    }
    
    /**
    Retrieve featured business with pagination enabled.
    */
    public func getMoreFeaturedBusinesses() -> SignalProducer<[FeaturedBusinessViewModel], NSError> {
        return fetchBusinesses(refresh: false)
    }
    
    /**
    Return a boolean value indicating whether there are still plenty of data for display.
    
    :param: index The index of the currently displaying Business.
    
    :returns: A Boolean value.
    */
    public func havePlentyOfData(index: Int) -> Bool {
        println(Double(index))
        println(Double(featuredBusinessViewModelArr.value.count))
        println(Double(featuredBusinessViewModelArr.value.count) - Double(Constants.PAGINATION_LIMIT) * Double(启动无限scrolling参数))
        
        return Double(index) < Double(featuredBusinessViewModelArr.value.count) - Double(Constants.PAGINATION_LIMIT) * Double(启动无限scrolling参数)
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
    
    // MARK: - Others
    
    /**
    Fetch featured businesses. If `refresh` is `true`, the function will replace the original list with new data, effectively refreshing the list. If `refresh` is `false`, the function will get data continuously like pagination.
    
    :param: refresh A `Boolean` value indicating whether the function should `refresh` or `get more like pagination`.
    */
    private func fetchBusinesses(refresh: Bool = false) -> SignalProducer<[FeaturedBusinessViewModel], NSError> {
        let query = Business.query()!
        // TODO: temporarily disabled until we have more featured businesses
        //        query.whereKey(Business.Property.Featured.rawValue, equalTo: true)
        query.limit = Constants.PAGINATION_LIMIT
        if refresh {
            // don't skip any content if we are refresh the list
            query.skip = 0
        }
        else {
            query.skip = numberOfBusinessesLoaded
        }
        
        return SignalProducer<[Business], NSError>.empty
            |> on(completed: { [weak self] in
                self?.isFetchingData.put(true)
            })
            |> then(businessService.findBy(query))
            |> on(next: { businesses in
                
                if refresh {
                    // set numberOfBusinessesLoaded to the number of businesses fetched
                    self.numberOfBusinessesLoaded = businesses.count
                    
                    // ignore old data, put in new array
                    self.businessArr.put(businesses)
                }
                else {
                    // increment numberOfBusinessesLoaded
                    self.numberOfBusinessesLoaded += businesses.count
                    
                    // save the new data in addition to the old ones
                    self.businessArr.put(self.businessArr.value + businesses)
                }
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
                next: { viewmodels in
                    if refresh {
                        // ignore old data
                        self.featuredBusinessViewModelArr.put(viewmodels)
                    }
                    else {
                        // save the new data with old ones
                        self.featuredBusinessViewModelArr.put(self.featuredBusinessViewModelArr.value + viewmodels)
                    }
                },
                error: { FeaturedLogError($0.description) }
            )
    }
}