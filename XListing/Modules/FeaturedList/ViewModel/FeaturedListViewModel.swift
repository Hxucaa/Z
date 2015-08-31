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
import ReactiveArray

private let 启动无限scrolling参数 = 0.4

public final class FeaturedListViewModel : IFeaturedListViewModel, ICollectionDataSource {
    
    public typealias Payload = FeaturedBusinessViewModel
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    public let collectionDataSource = ReactiveArray<FeaturedBusinessViewModel>()
    
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
    
    // MARK: - Initializers
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
    Retrieve featured business with pagination enabled.
    */
    
    public func fetchMoreData() -> SignalProducer<Void, NSError> {
        return fetchBusinesses(refresh: false)
            |> map { _ in }
    }
    
    public func refreshData() -> SignalProducer<Void, NSError> {
        return fetchBusinesses(refresh: true)
            |> map { _ in }
    }
    
    public func predictivelyFetchMoreData(targetContentIndex: Int) -> SignalProducer<Void, NSError> {
        // if there are still plenty of data for display, don't fetch more businesses
        if Double(targetContentIndex) < Double(collectionDataSource.count) - Double(Constants.PAGINATION_LIMIT) * Double(启动无限scrolling参数) {
            return SignalProducer<Void, NSError>.empty
        }
        // else fetch more data
        else {
            return fetchBusinesses(refresh: false)
                |> map { _ in }
        }
    }
    
    public func pushNearbyModule() {
        router.pushNearby()
    }
    
    public func pushSocialBusinessModule(section: Int) {
        router.pushSocialBusiness(businessArr.value[section])
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
            |> on(
                next: { viewmodels in
                    if refresh && viewmodels.count > 0 {
                        // ignore old data
                        self.collectionDataSource.replaceAll(viewmodels)
                    }
                    else if !refresh && viewmodels.count > 0 {
                        // save the new data with old ones
                        self.collectionDataSource.extend(viewmodels)
                    }
                },
                error: { FeaturedLogError($0.description) }
            )
    }
}