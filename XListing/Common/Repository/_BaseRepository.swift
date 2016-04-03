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

public class _BaseRepository<M: IModel, DAO: AVObject> {
    
    
    private let daoToModelMapper: DAO -> M
    
    init(daoToModelMapper: DAO -> M) {
        self.daoToModelMapper = daoToModelMapper
    }
    
    func _create(dao: DAO) -> Observable<Bool> {
        return dao.rx_save()
    }
    
    func findWithPagination(query: TypedAVQuery<DAO>, findMoreTrigger: Observable<Void>) -> Observable<[M]> {
        
        // TODO: Inject a globally configurable value
        query.limit = 30
        query.skip = 0
        
        
        return recursivelyFind(query, fetchedSoFar: [], findMoreTrigger: findMoreTrigger)
    }
    
    private func recursivelyFind(query: TypedAVQuery<DAO>, fetchedSoFar: [M], findMoreTrigger: Observable<Void>) -> Observable<[M]> {
        return query.rx_findObjects()
            .retry(3)
//            .observeOn(Scheduler.repositoryBackgroundScheduler)
            .mapToModel(self.daoToModelMapper)
            .flatMap { newModels -> Observable<[M]> in
                
                
                query.skip += newModels.count
                
                var fetched = fetchedSoFar
                fetched.appendContentsOf(newModels)
                
                
                return [
                    Observable.just(fetched).debug("33333"),
                    Observable.never().takeUntil(findMoreTrigger).debug("44444"),
                    self.recursivelyFind(query, fetchedSoFar: fetched, findMoreTrigger: findMoreTrigger).debug("55555")
                ].concat().debug("666666")
        }
    }
}
