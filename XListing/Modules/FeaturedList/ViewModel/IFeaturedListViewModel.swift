//
//  IFeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IFeaturedListViewModel {
    var featuredBusinessViewModelArr: MutableProperty<[FeaturedBusinessViewModel]> { get }
    var isFetchingData: MutableProperty<Bool> { get }
    init(router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService)
    func refreshFeaturedBusinesses() -> SignalProducer<[FeaturedBusinessViewModel], NSError>
    func getMoreFeaturedBusinesses() -> SignalProducer<[FeaturedBusinessViewModel], NSError>
    func havePlentyOfData(index: Int) -> Bool
    func pushNearbyModule()
    func pushDetailModule(section: Int)
    func pushProfileModule()
}