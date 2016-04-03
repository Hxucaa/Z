//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ReactiveArray

final class FeaturedListViewModel : _BaseViewModel, IFeaturedListViewModel, ViewModelInjectable {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    let collectionDataSource: Observable<[BusinessInfo]>
    
    // MARK: - Properties
    // MARK: Services
    private let businessRepository: IBusinessRepository
    private let userRepository: IUserRepository
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    
    
    // MARK: - Initializers
    typealias Dependency = (router: IRouter, businessRepository: IBusinessRepository, userRepository: IUserRepository, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService)
    
    typealias Token = Void
    
    typealias Input = (modelSelected: ControlEvent<BusinessInfo>, refreshTrigger: Observable<Void>, fetchMoreTrigger: Observable<Void>)
    
    init(dep: Dependency, token: Token, input: Input) {
        
        businessRepository = dep.businessRepository
        userRepository = dep.userRepository
        geoLocationService = dep.geoLocationService
        userDefaultsService = dep.userDefaultsService
        
        collectionDataSource = businessRepository.findByCurrentLocation(input.fetchMoreTrigger.debug("viewmodel"))
            .observeOn(MainScheduler.instance)
            .catchError {
                dep.router.presentError($0 as! NetworkError)
                return Observable.just([Business]())
            }
            .map { $0.map { BusinessInfo(business: $0) } }
        
        super.init(router: dep.router)
        
        input.modelSelected
            .subscribeNext {
                dep.router.toSoclaBusiness($0)
            }
            .addDisposableTo(disposeBag)
        
    }
    
    // MARK: - API
    
//    func predictivelyFetchMoreData(targetContentIndex: Int) -> SignalProducer<Void, NSError> {
//        // if there are still plenty of data for display, don't fetch more businesses
//        if Double(targetContentIndex) < Double(collectionDataSource.count) - Double(Constants.PAGINATION_LIMIT) * Double(启动无限scrolling参数) {
//            return SignalProducer<Void, NSError>.empty
//        }
//        // else fetch more data
//        else {
//            return fetchBusinesses(false)
//                .map { _ in }
//        }
//    }
    
    // MARK: - Others
    
}