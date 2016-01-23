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
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var collectionDataSource: ReactiveArray<SocialBusiness_UserViewModel> { get }
    var businessCoverImage: UIImage? { get }
    var businessName: AnyProperty<String> { get }
    var headerViewModel: SocialBusinessHeaderViewModel { get }
    
    // MARK: - Initializers
    init(userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService, business: Business)
    
    func pushUserProfile(index: Int, animated: Bool)
    func pushBusinessDetail(animated: Bool)
    func fetchMoreData() -> SignalProducer<Void, NSError>
    func refreshData() -> SignalProducer<Void, NSError>
    func predictivelyFetchMoreData(targetContentIndex: Int) -> SignalProducer<Void, NSError>
    func participate(choice: ParticipationType) -> SignalProducer<Bool, NSError>
    
}