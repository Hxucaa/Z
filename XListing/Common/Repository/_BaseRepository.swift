//
//  _BaseRepository.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-23.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public class _BaseRepository<M: IModel, DAO: AVObject> {
    
    
    private let daoToModelMapper: DAO -> M
    
    init(daoToModelMapper: DAO -> M) {
        self.daoToModelMapper = daoToModelMapper
    }
    
    //    func update(model: M) -> SignalProducer<Bool, NetworkError> {
    //        return
    //    }
    
    func _create(dao: DAO) -> SignalProducer<Bool, NetworkError> {
        return dao.rac_save()
    }
    
    public func find(findMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[M], NetworkError> {
        fatalError("Must override this function.")
    }
    
    func findWithPagination(query: TypedAVQuery<DAO>, findMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[M], NetworkError> {
        
        // TODO: Inject a globally configurable value
        query.limit = 30
        query.skip = 0
        
        
        return recursivelyFind(query, fetchedSoFar: [], findMoreTrigger: findMoreTrigger)
    }
    
    private func recursivelyFind(query: TypedAVQuery<DAO>, fetchedSoFar: [M], findMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[M], NetworkError> {
        return query.rac_findObjects()
            .retry(3)
            .observeOn(Scheduler.repositoryBackgroundScheduler)
            .mapToModel(self.daoToModelMapper)
            .flatMap(.Merge) { newModels -> SignalProducer<[M], NetworkError> in
                
                
                query.skip += newModels.count
                
                var fetched = fetchedSoFar
                fetched.appendContentsOf(newModels)
                
                
                return SignalProducer<SignalProducer<[M], NetworkError>, NetworkError>(values: [
                    SignalProducer<[M], NetworkError>(value: fetched),
                    SignalProducer.never.takeUntil(findMoreTrigger),
                    self.recursivelyFind(query, fetchedSoFar: fetched, findMoreTrigger: findMoreTrigger)
                    ]
                    ).flatten(.Concat)
        }
    }
}
