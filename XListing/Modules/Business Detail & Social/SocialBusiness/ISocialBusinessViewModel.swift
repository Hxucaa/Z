//
//  ISocialBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray

public protocol ISocialBusinessViewModel : class, IInfinityScrollDataSource, IPullToRefreshDataSource, IPredictiveScrollDataSource {
    var collectionDataSource: ReactiveArray<SocialBusiness_UserViewModel> { get }
    init(userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService, businessModel: Business)
    func pushUserProfile(index: Int, animated: Bool)
    func pushBusinessDetail(animated: Bool)
    func fetchMoreData() -> SignalProducer<Void, NSError>
    func refreshData() -> SignalProducer<Void, NSError>
    func predictivelyFetchMoreData(targetContentIndex: Int) -> SignalProducer<Void, NSError>
    
}