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

private let 启动无限scrolling参数 = 0.4

public protocol SocialBusinessNavigator : class {
    func pushUserProfile(user: User, animated: Bool)
    func pushBusinessDetail(business: Business, animated: Bool)
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
        return fetchParticipatingUsers(refresh: false)
            |> map { _ in }
    }
    
    public func refreshData() -> SignalProducer<Void, NSError> {
        return fetchParticipatingUsers(refresh: true)
            |> map { _ in }
    }
    
    public func predictivelyFetchMoreData(targetContentIndex: Int) -> SignalProducer<Void, NSError> {
        // if there are still plenty of data for display, don't fetch more users
        if Double(targetContentIndex) < Double(collectionDataSource.count) - Double(Constants.PAGINATION_LIMIT) * Double(启动无限scrolling参数) {
            return SignalProducer<Void, NSError>.empty
        }
            // else fetch more data
        else {
            return fetchParticipatingUsers(refresh: false)
                |> map { _ in }
        }
    }
    
    public func pushUserProfile(index: Int, animated: Bool) {
        navigator.pushUserProfile(collectionDataSource.array[index].user.value, animated: true)
        
    }
    
    private func fetchParticipatingUsers(refresh: Bool = false) -> SignalProducer<[SocialBusiness_UserViewModel], NSError> {
        let query = Participation.query()
        query.limit = Constants.PAGINATION_LIMIT
        query.skip = collectionDataSource.count
        query.includeKey(User_Business_Participation.Property.User.rawValue)
        query.includeKey(User_Business_Participation.Property.Business.rawValue)
        query.whereKey(User_Business_Participation.Property.Business.rawValue, equalTo: business)

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
            |> map { participations -> [SocialBusiness_UserViewModel] in
                
                var result = [SocialBusiness_UserViewModel]()
                for p in participations {
                    result.append(SocialBusiness_UserViewModel(participationService: self.participationService, imageService: self.imageService, user: p.user, nickname: p.user.nickname, ageGroup: p.user.ageGroup, horoscope: p.user.horoscope, gender: p.user.gender, profileImage: p.user.profileImg))
                    
                }
                return result

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
    
    public func pushBusinessDetail(animated: Bool) {
        let business = Business()
        business.nameSChinese = "hahah"
        navigator.pushBusinessDetail(business, animated: animated)
    }
    
    // MARK: - Others
}