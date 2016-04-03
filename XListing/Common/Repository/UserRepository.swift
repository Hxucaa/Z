//
//  UserRepository.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-21.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import AVOSCloud

public protocol IUserRepository {
    func findByParticipatingBusiness(businessId: String, fetchMoreTrigger: Observable<Void>) -> Observable<[User]>
}

public final class UserRepository : _BaseRepository, IUserRepository {
    
    private let geolocationService: IGeoLocationService
    
    public init(geolocationService: IGeoLocationService) {
        self.geolocationService = geolocationService
        
        super.init()
    }
    
    private func createQuery() -> TypedAVQuery<UserDAO> {
        let query = UserDAO.typedQuery
        query.includeKey(BusinessDAO.Property.address)
        
        return query
    }
    
    public func findByParticipatingBusiness(businessId: String, fetchMoreTrigger: Observable<Void>) -> Observable<[User]> {
        let query = EventDAO.typedQuery
        query.includeKey(EventDAO.Property.Iniator)
        query.whereKey(EventDAO.Property.Business, equalTo: BusinessDAO(outDataWithObjectId: businessId))
        
        return findWithPagination(query, findMoreTrigger: fetchMoreTrigger)
            .map { $0.map { $0.initiator.toUser() } }
    }
}
