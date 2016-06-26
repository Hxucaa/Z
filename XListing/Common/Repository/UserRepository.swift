//
//  UserRepository.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-21.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import AVOSCloud

public protocol IUserRepository : IBaseRepository {
    func findAPreviewOfParticipants(business: Business) -> Observable<[User]>
    func findAPreviewOfParticipants(business: Business, limit: Int) -> Observable<[User]>
    func findByParticipatingBusiness(businessId: String, fetchMoreTrigger: Observable<Void>) -> Observable<[User]>
    
}

public final class UserRepository : _BaseRepository, IUserRepository {
    
    private let geolocationService: IGeoLocationService
    
    public init(geolocationService: IGeoLocationService, activityIndicator: ActivityIndicator, schedulers: IWorkSchedulers) {
        self.geolocationService = geolocationService
        
        super.init(activityIndicator: activityIndicator, schedulers: schedulers)
    }
    
    private func createQuery() -> TypedAVQuery<UserDAO> {
        let query = UserDAO.typedQuery
        query.includeKey(BusinessDAO.Property.address)
        
        return query
    }
    
    public func findAPreviewOfParticipants(business: Business) -> Observable<[User]> {
        return findAPreviewOfParticipants(business, limit: 5)
    }
    
    public func findAPreviewOfParticipants(business: Business, limit: Int) -> Observable<[User]> {
        let query = EventDAO.typedQuery
        query.includeKey(EventDAO.Property.Iniator)
        query.whereKey(EventDAO.Property.Business, equalTo: BusinessDAO(objectId: business.objectId))
        query.limit = limit
        
        return find(query)
            .map { $0.map { $0.initiator.toUser() } }
    }
    
    public func findByParticipatingBusiness(businessId: String, fetchMoreTrigger: Observable<Void>) -> Observable<[User]> {
        let query = EventDAO.typedQuery
        query.includeKey(EventDAO.Property.Iniator)
        query.whereKey(EventDAO.Property.Business, equalTo: BusinessDAO(objectId: businessId))
        
        return findWithPagination(query, findMoreTrigger: fetchMoreTrigger)
            .map { $0.map { $0.initiator.toUser() } }
    }
}
