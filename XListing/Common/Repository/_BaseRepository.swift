//
//  _BaseRepository.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-23.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import AVOSCloud

public protocol IBaseRepository {
    var activityIndicator: ActivityIndicator { get }
}

public class _BaseRepository {
    
    public let activityIndicator: ActivityIndicator
    let schedulers: IWorkSchedulers
    
    init(activityIndicator: ActivityIndicator, schedulers: IWorkSchedulers) {
        self.activityIndicator = activityIndicator
        self.schedulers = schedulers
    }
    
    func _create<DAO: AVObject>(dao: DAO) -> Observable<Bool> {
        return dao.rx_save()
    }
    
    func findWithPagination<DAO: AVObject>(query: TypedAVQuery<DAO>, findMoreTrigger: Observable<Void>) -> Observable<[DAO]> {
        
        // TODO: Inject a globally configurable value
        query.limit = 10
        query.skip = 0
        
        
        return recursivelyFind(query, fetchedSoFar: [], findMoreTrigger: findMoreTrigger)
    }
    
    private func recursivelyFind<DAO: AVObject>(query: TypedAVQuery<DAO>, fetchedSoFar: [DAO], findMoreTrigger: Observable<Void>) -> Observable<[DAO]> {
        return query.rx_findObjects()
            .retry(3)
            .trackActivity(activityIndicator)
            .observeOn(schedulers.background)
            .flatMap { newModels -> Observable<[DAO]> in
                
                
                query.skip += newModels.count
                
                var fetched = fetchedSoFar
                fetched.appendContentsOf(newModels)
                
                
                return [
                    Observable.just(fetched),
                    Observable.never().takeUntil(findMoreTrigger),
                    self.recursivelyFind(query, fetchedSoFar: fetched, findMoreTrigger: findMoreTrigger)
                ].concat()
        }
    }
}
