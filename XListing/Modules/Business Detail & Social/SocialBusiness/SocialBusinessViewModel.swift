//
//  SocialBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AVOSCloud
import Dollar

private let 启动无限scrolling参数 = 0.4

protocol SocialBusinessNavigator : class {
    func pushUserProfile(user: User, animated: Bool)
    func pushBusinessDetail(business: Business, animated: Bool)
}


final class SocialBusinessViewModel : _BaseViewModel, ISocialBusinessViewModel {
    
//    typealias Payload = SocialBusiness_UserViewModel
    
    // MARK: - Inputs
    
    // MARK: - Outputs
//    let collectionDataSource = ReactiveArray<SocialBusiness_UserViewModel>()
//    var businessCoverImage: UIImage? {
//        return headerViewModel.coverImage.value
//    }
    
//    private let _businessName: MutableProperty<String>
//    var businessName: AnyProperty<String> {
//        return AnyProperty(_businessName)
//    }
//    
//    private let _isButtonEnabled: MutableProperty<Bool> = MutableProperty(true)
//    var isButtonEnabled: AnyProperty<Bool> {
//        return AnyProperty(_isButtonEnabled)
//    }
    
    // MARK: - Properties
    
    // MARK: - View Models
//    let headerViewModel: SocialBusinessHeaderViewModel
    
    // MARK: - Outputs
    
    var businessName: String {
        return business.name
    }
    
    var businessImageURL: NSURL? {
        return business.coverImageUrl
    }
    
    var city: String {
        return business.city
    }
    
    // MARK: Services
    private let meRepository: IMeRepository
    private let businessRepository: IBusinessRepository
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    // MARK: Variables
    private let business: BusinessInfo
    
    // MARK: - Initializers
    init(dep: (router: IRouter, meRepository: IMeRepository, businessRepository: IBusinessRepository, geoLocationService: IGeoLocationService, imageService: IImageService, business: BusinessInfo), input: (modelSelected: ControlEvent<BusinessInfo>, refreshTrigger: Observable<Void>, fetchMoreTrigger: Observable<Void>)) {
        
        meRepository = dep.meRepository
        businessRepository = dep.businessRepository
        geoLocationService = dep.geoLocationService
        imageService = dep.imageService
        business = dep.business
        
        super.init(router: dep.router)
//        headerViewModel = SocialBusinessHeaderViewModel(geoLocationService: geoLocationService, imageService: imageService, coverImage: business.coverImage, name: business.name, city: business.address.city, geolocation: business.address.geoLocation)
        
        
    }
    
    // MARK: - API
    
    func calculateEta() -> Driver<String> {
        return geoLocationService.calculateETA(business.geolocation)
            .map { "\($0)分钟" }
            .asDriver(onErrorJustReturn: "")
    }
    
//    func fetchMoreData() -> SignalProducer<Void, NSError> {
//        return fetchParticipatingUsers(false)
//            .map { _ in }
//    }
//    
//    func refreshData() -> SignalProducer<Void, NSError> {
//        return fetchParticipatingUsers(true)
//            .map { _ in }
//    }
//    
//    func predictivelyFetchMoreData(targetContentIndex: Int) -> SignalProducer<Void, NSError> {
//        // if there are still plenty of data for display, don't fetch more users
//        if Double(targetContentIndex) < Double(collectionDataSource.count) - Double(Constants.PAGINATION_LIMIT) * Double(启动无限scrolling参数) {
//            return SignalProducer<Void, NSError>.empty
//        }
//            // else fetch more data
//        else {
//            return fetchParticipatingUsers(false)
//                .map { _ in }
//        }
//    }
    
//    func pushUserProfile(index: Int, animated: Bool) {
//        navigator.pushUserProfile(collectionDataSource.array[index].user, animated: true)
//        
//    }
    
    private func fetchParticipatingUsers(refresh: Bool = false) -> SignalProducer<[SocialBusiness_UserViewModel], NSError> {
        let query = EventDAO.query()
        query.limit = Constants.PAGINATION_LIMIT
        query.skip = collectionDataSource.count
        query.includeKey(EventDAO.Property.Iniator.rawValue)
        query.whereKey(EventDAO.Property.Business.rawValue, equalTo: business)

        return participationService.findBy(query)
            .map { participations -> [SocialBusiness_UserViewModel] in

                return participations.map {
                    SocialBusiness_UserViewModel(participationService: self.participationService, imageService: self.imageService, user: $0.user, participationType: $0.type)
                }

            }
            .on(
                next: { viewmodels in
                    if refresh && viewmodels.count > 0 {
                        // ignore old data
                        self.collectionDataSource.replaceAll(viewmodels)
                    }
                    else if !refresh && viewmodels.count > 0 {
                        // save the new data with old ones
                        self.collectionDataSource.appendContentsOf(viewmodels)
                    }
                },
                failed: { DetailLogError($0.description) }
            )
    }
    
    func pushBusinessDetail(animated: Bool) {
        navigator.pushBusinessDetail(business, animated: animated)
    }
    
    
    /**
     Participate Button Action

     - parameter choice: ParticipationChoice

     - returns: A signal producer
     */
    func participate(choice: EventType) -> SignalProducer<Bool, NSError> {
        return self.meService.currentLoggedInUser()
            .flatMap(FlattenStrategy.Concat) { user -> SignalProducer<Bool, NSError> in
                let p = Event()
                p.user = user
                p.business = self.business
                p.type = choice

                return self.participationService.create(p)
            }
            .on(next: { [weak self] success in
                // if operation is successful, change the participation button.
                if success {
                    self?._isButtonEnabled.value = false
                }
            })
    }
    
    
    // MARK: - Others
}