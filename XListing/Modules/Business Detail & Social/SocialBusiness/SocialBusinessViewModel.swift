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
    private let userArr: MutableProperty<[Participation]> = MutableProperty([Participation]())
    
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
        return fetchParticipatingUsers()
            |> map { _ in }
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
    
    private func fetchParticipatingUsers(refresh: Bool = false) -> SignalProducer<[SocialBusiness_UserViewModel], NSError> {
        let query = Participation.query()
        query.limit = Constants.PAGINATION_LIMIT

        return SignalProducer<[Participation], NSError>.empty
            |> then(participationService.findBy(query))
            |> on(next: { participation in
                
                if refresh {
                    // ignore old data, put in new array
                    self.userArr.put(participation)
                }
                else {
                    // save the new data in addition to the old ones
                    self.userArr.put(self.userArr.value + participation)
                }
            })
            |> map { blah -> [SocialBusiness_UserViewModel] in
                
                var result = [SocialBusiness_UserViewModel]()
                for p in blah {
                    result.append(SocialBusiness_UserViewModel(participationService: self.participationService, imageService: self.imageService, user: p.user))
                }
                return result
                
                // map the participation models to viewmodels
                //return participations.map {
                    //SocialBusiness_UserViewModel(participationService: self.participationService, imageService: self.imageService, user: $0)
                //}
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
                error: { DetailLogError($0.description) }
        )
        
    }
    
    // MARK: - Others
}