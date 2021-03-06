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
    
    // MARK: - Outputs
    
    var collectionDataSource: ReactiveArray<FeaturedBusinessViewModel> { get }
    
    init(businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService,  participationService: IParticipationService)
    
    func pushSocialBusinessModule(section: Int)
}