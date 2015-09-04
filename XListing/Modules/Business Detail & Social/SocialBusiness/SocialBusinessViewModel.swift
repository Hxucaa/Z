//
//  SocialBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import Dollar
import ReactiveArray

public protocol SocialBusinessNavigator : class {
    func pushUserProfile(user: User, animated: Bool)
}


public final class SocialBusinessViewModel : ISocialBusinessViewModel, ICollectionDataSource  {
    
    public typealias Payload = SocialBusiness_UserViewModel
    
    // MARK: - Inputs
    public let collectionDataSource = ReactiveArray<SocialBusiness_UserViewModel>()
    
    // MARK: - Outputs
    
    // MARK: - Properties
    // MARK: Services
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let business: Business
    
    // MARK: Variables
    public weak var navigator: SocialBusinessNavigator!
    
    // MARK: - Initializers
    public required init(userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService, businessModel: Business) {
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.business = businessModel
        
    }
    
    // MARK: - API
    
    public func fetchMoreData() -> SignalProducer<Void, NSError> {
        fatalError("Not yet implemented")
    }
    
    public func refreshData() -> SignalProducer<Void, NSError> {
        fatalError("Not yet implemented")
    }
    
    public func predictivelyFetchMoreData(targetContentIndex: Int) -> SignalProducer<Void, NSError> {
        fatalError("Not yet implemented")
    }
    
    public func pushUserProfile(index: Int, animated: Bool) {
        fatalError("Not yet implemented")
        
    }
    
    // MARK: - Others
}