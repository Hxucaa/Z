////
////  ParticipationListViewModel.swift
////  XListing
////
////  Created by Lance Zhu on 2015-10-07.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//import ReactiveCocoa
//import Dollar
//import ReactiveArray
//
//public final class ParticipationListViewModel : IParticipationListViewModel, ICollectionDataSource {
//    
//    public typealias Payload = IParticipationListCellViewModel
//    
//    
//    // MARK: - Inputs
//    
//    // MARK: - Outputs
//    public let collectionDataSource = ReactiveArray<Payload>()
//    
//    // MARK: - Properties
//    // MARK: Services
//    private let businessService: IBusinessService
//    private let participationService: IParticipationService
//    private let meService: IMeService
//    private let geoLocationService: IGeoLocationService
//    private let imageService: IImageService
//    
//    // MARK: Variables
//    private var participationArr = [Participation]()
//    private var businessArr = [Business]()
//    private var numberOfParticipationsLoaded = 0
//    private let 启动无限scrolling参数 = 0.4
//    
//    public weak var navigator: ProfileNavigator? 
//    
//    // MARK: - Initializers
//    public init(participationService: IParticipationService, businessService: IBusinessService, meService: IMeService, geoLocationService: IGeoLocationService, imageService: IImageService) {
//        
//        self.participationService = participationService
//        self.businessService = businessService
//        self.meService = meService
//        self.geoLocationService = geoLocationService
//        self.imageService = imageService
//        
//    }
//    
//    // MARK: - API
//    
//    public func fetchMoreData() -> SignalProducer<Void, NSError> {
//        return meService.currentLoggedInUser()
//            .on(next: { user in
//                self.getParticipations(user, refresh: false)
//                    .start()
//            })
//            .map { _ in }
//    }
//    
//    public func refreshData() -> SignalProducer<Void, NSError> {
//        return meService.currentLoggedInUser()
//            .on(next: { user in
//                self.getParticipations(user, refresh: true)
//                    .start()
//            })
//            .map { _ in }
//    }
//    
//    public func predictivelyFetchMoreData(targetContentIndex: Int) -> SignalProducer<Void, NSError> {
//        // if there are still plenty of data for display, don't fetch more businesses
//        if Double(targetContentIndex) < Double(collectionDataSource.count) - Double(Constants.PAGINATION_LIMIT) * Double(启动无限scrolling参数) {
//            return SignalProducer<Void, NSError>.empty
//        }
//            // else fetch more data
//        else {
//            return meService.currentLoggedInUser()
//                .on(next: { user in
//                    self.getParticipations(user, refresh: false)
//                        .start()
//                })
//                .map { _ in }
//        }
//    }
//    
//    public func removeDataAtIndex(index: Int) -> SignalProducer<Bool, NSError> {
//        return participationService.delete(participationArr[index])
//            .on(
//                next: { [weak self] _ in
//                    ProfileLogInfo("participation backend completed")
//                    if let this = self {
//                        this.participationArr.removeAtIndex(index)
//                        this.collectionDataSource.removeAtIndex(index)
//                    }
//                }
//        )
//        
//    }
//    
//    public func pushSocialBusinessModule(section: Int, animated: Bool) {
//        if let nav = navigator {
//            nav.pushSocialBusiness(businessArr[section], animated: animated)
//        }
//    }
//    
//    public func getBusinessAtIndex(index: Int) -> Business {
//        return businessArr[index]
//    }
//    
//    
//    // MARK: - Others
//    
//    public func getParticipations(user : User, refresh: Bool) -> SignalProducer<[IParticipationListCellViewModel], NSError> {
//        let query = Participation.query()!
//        typealias Property = Participation.Property
//        query.whereKey(Property.User.rawValue, equalTo: user)
//        query.includeKey(Property.Business.rawValue)
//        query.limit = Constants.PAGINATION_LIMIT
//        if refresh {
//            // don't skip any content if we are refresh the list
//            query.skip = 0
//        }
//        else {
//            query.skip = numberOfParticipationsLoaded
//        }
//        
//        
//        return participationService.findBy(query)
//            .on(next: { participations in
//                if refresh {
//                    self.numberOfParticipationsLoaded = participations.count
//                    // ignore old data, put in new array
//                    self.participationArr = participations
//                    self.businessArr = (participations.map { $0.business })
//                }
//                else {
//                    // increment numberOfBusinessesLoaded
//                    self.numberOfParticipationsLoaded += participations.count
//                    
//                    // save the new data in addition to the old ones
//                    self.participationArr.appendContentsOf(participations)
//                    self.businessArr.appendContentsOf(participations.map { $0.business })
//                }
//            })
//            .map { participations -> [IParticipationListCellViewModel] in
//                
//                // map participation to its view model
//                return participations.map {
//                    let business = $0.business
//                    let viewmodel = ParticipationListCellViewModel(meService: self.meService, geoLocationService: self.geoLocationService, imageService: self.imageService, participationService: self.participationService, coverImage: business.coverImage, geolocation: business.address.geoLocation, business: business, type: $0.type)
//                    return viewmodel
//                }
//            }
//            .on(
//                next: { viewmodels in
//                    if refresh && viewmodels.count > 0 {
//                        // ignore old data
//                        self.collectionDataSource.replaceAll(viewmodels)
//                    }
//                    else if !refresh && viewmodels.count > 0 {
//                        // save the new data with old ones
//                        self.collectionDataSource.appendContentsOf(viewmodels)
//                    }
//                },
//                failed: { ProfileLogError($0.customErrorDescription) }
//        )
//    }
//}