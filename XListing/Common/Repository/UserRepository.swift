//
//  UserRepository.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-21.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public protocol IUserRepository {
    
}

public final class UserRepository : _BaseRepository<User, UserDAO>, IUserRepository {
    
    private let geolocationService: IGeoLocationService
    
    public init(geolocationService: IGeoLocationService) {
        self.geolocationService = geolocationService
        
        super.init(daoToModelMapper: { $0.toUser() })
    }
    
    public override func find(findMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[User], NetworkError> {
        let query = createQuery()
        
        return findWithPagination(query, findMoreTrigger: findMoreTrigger)
    }
    
    private func createQuery() -> TypedAVQuery<UserDAO> {
        let query = UserDAO.typedQuery
        query.includeKey(BusinessDAO.Property.address)
        
        return query
    }
}
