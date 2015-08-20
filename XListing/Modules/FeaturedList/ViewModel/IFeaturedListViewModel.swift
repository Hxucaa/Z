//
//  IFeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IFeaturedListViewModel : ICollectionDataSource, IInfinityScrollable, IPullToRefreshable, IPredictiveScrollable {
    var isFetchingData: MutableProperty<Bool> { get }
    init(router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService)
    func pushNearbyModule()
    func pushDetailModule(section: Int)
    func pushProfileModule()
}