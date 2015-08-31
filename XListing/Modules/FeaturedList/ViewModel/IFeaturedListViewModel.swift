//
//  IFeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray

public protocol IFeaturedListViewModel : IInfinityScrollDataSource, IPullToRefreshDataSource, IPredictiveScrollDataSource {
    var collectionDataSource: ReactiveArray<FeaturedBusinessViewModel> { get }
    init(router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService,  participationService: IParticipationService)
    func pushNearbyModule()
    func pushDetailModule(section: Int)
    func pushProfileModule()
}