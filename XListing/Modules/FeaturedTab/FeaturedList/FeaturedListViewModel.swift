//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import Dollar
import ReactiveArray

private let 启动无限scrolling参数 = 0.4

final class FeaturedListViewModel : IFeaturedListViewModel {
    
//    typealias Payload = BusinessInfo
    
    // MARK: - Inputs
    
    // MARK: - Outputs
//    let collectionDataSource = ReactiveArray<BusinessInfo>()
    let collectionDataSource = MutableProperty<[BusinessInfo]>([BusinessInfo]())
    
//    let businessList: SignalProducer<[Business], NetworkError>
    
    // MARK: - Properties
    // MARK: Services
    private let router: IRouter
    private let businessRepository: IBusinessRepository
    private let userRepository: IUserRepository
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    
    // MARK: Variables
    private var numberOfBusinessesLoaded = 0
    
    // MARK: - Initializers
    init(dep: (router: IRouter, businessRepository: IBusinessRepository, userRepository: IUserRepository, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService), input: (didSelectRow: SignalProducer<NSIndexPath, NoError>, refreshTrigger: SignalProducer<Void, NoError>, fetchMoreTrigger: SignalProducer<Void, NoError>)) {
        
        router = dep.router
        businessRepository = dep.businessRepository
        userRepository = dep.userRepository
        geoLocationService = dep.geoLocationService
        userDefaultsService = dep.userDefaultsService
        
        collectionDataSource <~ businessRepository.findByCurrentLocation(input.fetchMoreTrigger.on(next: { print($0) }))
            .presentErrorView(router)
            .map { $0.map { BusinessInfo(business: $0) } }
        
        input.didSelectRow
            .map { $0.row }
            .startWithNext { [unowned self] in
                self.router.toSoclaBusiness(undefined())
            }
        
    }
    
    // MARK: - API
    
//    func didSelectRow(indexPath: NSIndexPath) -> SignalProducer<Void, NSError> {
//        
//    }
    
    /**
    Retrieve featured business with pagination enabled.
    */
    
//    func fetchMoreData() -> SignalProducer<Void, NSError> {
//        return fetchBusinesses(false)
//            .map { _ in }
//    }
    
//    func refreshData() -> SignalProducer<Void, NSError> {
//        return fetchBusinesses(true)
//            .map { _ in }
//    }
    
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
    
//    func pushSocialBusinessModule(section: Int) {
//        router.toSoclaBusiness(collectionDataSource.array[section].business, callback: nil)
//    }
    
    // MARK: - Others
    
//    private func calculateEta(destination: CLLocation) -> SignalProducer<NSTimeInterval, NSError> {
//        return geoLocationService.calculateETA(destination)
//            .on(
//                next: { interval in
//                    let minute = Int(ceil(interval / 60))
////                    self._eta.value = "\(minute)分钟"
//                },
//                failed: { FeaturedLogError($0.description) }
//        )
//    }
    
//    /**
//    Fetch featured businesses. If `refresh` is `true`, the function will replace the original list with new data, effectively refreshing the list. If `refresh` is `false`, the function will get data continuously like pagination.
//    
//    - parameter refresh: A `Boolean` value indicating whether the function should `refresh` or `get more like pagination`.
//    
//    - returns: A signal producer.
//    */
//    private func fetchBusinesses(refresh: Bool = false) -> SignalProducer<[FeaturedBusinessViewModel], NSError> {
//        let query = Business.query()
//        // TODO: temporarily disabled until we have more featured businesses
//        //        query.whereKey(Business.Property.Featured.rawValue, equalTo: true)
//        query.limit = Constants.PAGINATION_LIMIT
//        query.includeKey(Business.Property.address)
//        if refresh {
//            // don't skip any content if we are refresh the list
//            query.skip = 0
//        }
//        else {
//            query.skip = numberOfBusinessesLoaded
//        }
//        
//        return businessService.findBy(query)
//            .map { $.shuffle($0) }
//            .on(next: { businesses in
//                
//                if refresh {
//                    // set numberOfBusinessesLoaded to the number of businesses fetched
//                    self.numberOfBusinessesLoaded = businesses.count
//                }
//                else {
//                    // increment numberOfBusinessesLoaded
//                    self.numberOfBusinessesLoaded += businesses.count
//                }
//            })
//            .map { businesses -> [FeaturedBusinessViewModel] in
//                
//                // map the business models to viewmodels
//                return businesses.map { business in
//                    let cellViewModel = FeaturedBusinessViewModel(userService: self.userService, geoLocationService: self.geoLocationService, imageService: self.imageService, participationService: self.participationService, business: business)
//                    
//                    cellViewModel.calculateEta()
//                        .start()
//                    
//                    return cellViewModel
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
//                failed: { FeaturedLogError($0.description) }
//            )
//    }
}