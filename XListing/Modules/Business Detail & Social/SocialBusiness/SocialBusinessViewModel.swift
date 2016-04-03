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

protocol ViewModelInjectable {
    associatedtype Dependency
    associatedtype Token
    associatedtype Input
    
    static func inject(dep: Dependency) -> (Token) -> (Input) -> Self
    
    init(dep: Dependency, token: Token, input: Input)
}

extension ViewModelInjectable {
    static func inject(dep: Dependency) -> (Token) -> (Input) -> Self {
        return { token in
            return { input in
                return Self(dep: dep, token: token, input: input)
            }
        }
    }
}

final class SocialBusinessViewModel : _BaseViewModel, ISocialBusinessViewModel, ViewModelInjectable {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    let collectionDataSource: Observable<[UserInfo]>
    
    var businessName: String {
        return business.name
    }
    
    var businessImageURL: NSURL? {
        return business.coverImageUrl
    }
    
    var city: String {
        return business.city
    }
    
    // MARK: - Properties
    
    
    // MARK: Services
    private let meRepository: IMeRepository
    private let businessRepository: IBusinessRepository
    private let userRepository: IUserRepository
    private let geoLocationService: IGeoLocationService
    
    // MARK: Variables
    private let business: BusinessInfo
    
    // MARK: - Initializers
    typealias Dependency = (router: IRouter, meRepository: IMeRepository, businessRepository: IBusinessRepository, userRepository: IUserRepository, geoLocationService: IGeoLocationService)
    
    typealias Token = (BusinessInfo)
    
    typealias Input = (navigateBack:  ControlEvent<Void>, navigateToDetailPage: Observable<Void>, userInfoSelected: ControlEvent<UserInfo>, refreshTrigger: Observable<Void>, fetchMoreTrigger: Observable<Void>)
    
    init(dep: Dependency, token: Token, input: Input) {
        
        meRepository = dep.meRepository
        businessRepository = dep.businessRepository
        userRepository = dep.userRepository
        geoLocationService = dep.geoLocationService
        business = token
        
        collectionDataSource = userRepository.findByParticipatingBusiness(token.objectId, fetchMoreTrigger: input.fetchMoreTrigger)
            .observeOn(MainScheduler.instance)
            .catchError {
                dep.router.presentError($0 as! NetworkError)
                return Observable.just([User]())
            }
            .map { $0.map { UserInfo(user: $0) } }
        
        super.init(router: dep.router)
        
        input.navigateBack
            .subscribeNext { dep.router.popViewController(false) }
            .addDisposableTo(disposeBag)
        
        input.navigateToDetailPage
            .subscribeNext {
                // TODO: Navigate to next page.
            }
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - API
    
    func calculateEta() -> Driver<String> {
        return geoLocationService.calculateETA(business.geolocation)
            .map { "\($0)分钟" }
            .asDriver(onErrorJustReturn: "")
    }
    
//    /**
//     Participate Button Action
//
//     - parameter choice: ParticipationChoice
//
//     - returns: A signal producer
//     */
//    func participate(choice: EventType) -> SignalProducer<Bool, NSError> {
//        return self.meService.currentLoggedInUser()
//            .flatMap(FlattenStrategy.Concat) { user -> SignalProducer<Bool, NSError> in
//                let p = Event()
//                p.user = user
//                p.business = self.business
//                p.type = choice
//
//                return self.participationService.create(p)
//            }
//            .on(next: { [weak self] success in
//                // if operation is successful, change the participation button.
//                if success {
//                    self?._isButtonEnabled.value = false
//                }
//            })
//    }
    
    
    // MARK: - Others
}