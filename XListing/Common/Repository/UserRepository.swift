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
    
    private func createQuery() -> TypedAVQuery<UserDAO> {
        let query = UserDAO.typedQuery
        query.includeKey(BusinessDAO.Property.address)
        
        return query
    }
}
