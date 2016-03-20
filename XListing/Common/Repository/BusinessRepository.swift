//
//  BusinessRepository.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public protocol IBusinessRepository {
    
}

public final class BusinessRepository : IBusinessRepository {
    
    public func getFeatureds(getMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[Business], NSError> {
        let query = BusinessDAO.query()
        query.includeKey(BusinessDAO.Property.address)
        query.limit = 20
        query.skip = 0
        
        return undefined()
    }
    
    private func recursivelyGet(query: AVQuery, fetchedSoFar: [Business], fetchMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[Business], NSError> {
        
        return query.rac_findObjects()
            .retry(3)
            .observeOn(Scheduler.repositoryBackgroundScheduler)
            .map { $0 as! [BusinessDAO] }
            .map { $0.map { $0.toBusiness() } }
            .flatMap(.Merge) { businesses -> SignalProducer<[Business], NSError> in
                
                
                query.skip = businesses.count
                
                var fetchedBusiness = fetchedSoFar
                fetchedBusiness.appendContentsOf(businesses)
                
                
                return SignalProducer<SignalProducer<[Business], NSError>, NSError>(values: [
                    SignalProducer<[Business], NSError>(value: fetchedBusiness),
                    SignalProducer.never.takeUntil(fetchMoreTrigger),
                    self.recursivelyGet(query, fetchedSoFar: fetchedBusiness, fetchMoreTrigger: fetchMoreTrigger)
                    ]
                    ).flatten(.Concat)
            }
    }
    
//    public func getFeatureds(getMoreTrigger: Observable<Void>) -> Observable<[Business]> {
//        let query = BusinessDAO.query()
//        query.includeKey(BusinessDAO.Property.address)
//        query.limit = 20
//        query.skip = 0
//        
//        return recursivelyFetch(query, fetchedSoFar: [], fetchMoreTrigger: getMoreTrigger)
//    }
//    
//    private func recursivelyFetch(query: AVQuery, fetchedSoFar: [Business], fetchMoreTrigger: Observable<Void>) -> Observable<[Business]> {
//        
//        return query.rx_findObjects()
//            .retry(3)
//            .observeOn(RxScheduler.sharedInstance.backgroundWorkScheduler)
//            .map { $0 as! [BusinessDAO] }
//            .map { $0.map { $0.toBusiness() } }
//            .flatMap { businesses -> Observable<[Business]> in
//                
//                query.skip = businesses.count
//                
//                var fetchedBusiness = fetchedSoFar
//                fetchedBusiness.appendContentsOf(businesses)
//                
//                return [
//                    // return loaded immediately
//                    Observable.just(fetchedBusiness),
//                    // wait until next page can be loaded
//                    Observable.never().takeUntil(fetchMoreTrigger),
//                    // load next page
//                    self.recursivelyFetch(query, fetchedSoFar: fetchedBusiness, fetchMoreTrigger: fetchMoreTrigger)
//                    ].concat()
//        }
//    }
}
