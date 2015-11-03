//
//  ParticipationListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Dollar
import ReactiveArray

public final class ParticipationListViewModel : IParticipationListViewModel, ICollectionDataSource {
    
    public typealias Payload = IParticipationListCellViewModel
    
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    public let collectionDataSource = ReactiveArray<Payload>()
    
    // MARK: - Properties
    // MARK: Services
    private let businessService: IBusinessService
    private let participationService: IParticipationService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    // MARK: Variables
    private let participationArr: MutableProperty<[Participation]> = MutableProperty([Participation]())
    private let businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
    
    // MARK: - Initializers
    public init(participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        
        self.participationService = participationService
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
    }
    
    // MARK: - API
    
    public func fetchMoreData() -> SignalProducer<Void, NSError> {
        return undefined()
    }
    
    public func refreshData() -> SignalProducer<Void, NSError> {
        return undefined()
    }
    
    public func predictivelyFetchMoreData(targetContentIndex: Int) -> SignalProducer<Void, NSError> {
        return undefined()
    }
    
    public func removeDataAtIndex(index: Int) -> SignalProducer<Void, NSError> {
        return undefined()
//        collectionDataSource.removeAtIndex(index)
    }
    
    public func pushSocialBusinessModule(section: Int, animated: Bool) {
        //        navigator.pushSocialBusiness(businessArr.value[section], animated: animated)
    }
    
//    public func undoParticipation(index: Int) -> SignalProducer<Bool, NSError> {
//        return participationService.delete(participationArr.value[index])
//            .on(
//                next: { _ in
//                    ProfileLogInfo("participation backend completed")
//                    self.participationArr.value.removeAtIndex(index)
//                }
//        )
//    }
    
    // MARK: - Others
    
//    private func getParticipations(user : User) -> SignalProducer<[ProfileBusinessViewModel], NSError> {
//        let query = Participation.query()!
//        typealias Property = Participation.Property
//        query.whereKey(Property.User.rawValue, equalTo: user)
//        query.includeKey(Property.Business.rawValue)
//        
//        return participationService.findBy(query)
//            .on(next: { participations in
//                self.participationArr.put(participations)
//                self.businessArr.put(participations.map { $0.business })
//            })
//            .map { participations -> [ProfileBusinessViewModel] in
//                
//                // map participation to its view model
//                return participations.map {
//                    let business = $0.business
//                    let viewmodel = ProfileBusinessViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: business.nameSChinese, city: business.city, district: business.district, cover: business.cover_, geolocation: business.geolocation, aaCount: business.aaCount, treatCount: business.treatCount, toGoCount: business.toGoCount)
//                    return viewmodel
//                }
//            }
//            .on(
//                next: { response in
//                    self.profileBusinessViewModelArr.put(response)
//                },
//                error: { ProfileLogError($0.customErrorDescription) }
//        )
//    }
}