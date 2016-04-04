//
//  BusinessRepository.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import AVOSCloud

public protocol IBusinessRepository {
//    func startEvent(business: Business) -> Observable
//    func cancelEvent(business: Business) -> Observable
//    func completeEvent(business: Business) -> Observable
    func openEvent(business: Business, eventType type: EventType) -> Observable<Event>
    func findByCurrentLocation(findMoreTrigger: Observable<Void>) -> Observable<[Business]>
    func findByRadiusFromOrigin(origin: CLLocation, radius: Double, findMoreTrigger: Observable<Void>) -> Observable<[Business]>
}

public final class BusinessRepository : _BaseRepository, IBusinessRepository {
    
    private let geolocationService: IGeoLocationService
    
    public init(geolocationService: IGeoLocationService, activityIndicator: ActivityIndicator, schedulers: IWorkSchedulers) {
        self.geolocationService = geolocationService
        
        super.init(activityIndicator: activityIndicator, schedulers: schedulers)
    }
    
    
    
    public func findByCurrentLocation(findMoreTrigger: Observable<Void>) -> Observable<[Business]> {
        
        return geolocationService.rx_getCurrentGeoPoint()
            // TODO: A more generic handling of default location when location service fails
            // TODO: Some kind of prompt for when location service is disabled
            .catchErrorJustReturn(CLLocation(latitude: 49.27623, longitude: -123.12941))
            // TODO: Extract constant number away
            .flatMapLatest {
                self.findByRadiusFromOrigin($0, radius: 1000 * 10, findMoreTrigger: findMoreTrigger)
            }
        
    }
    
    public func openEvent(business: Business, eventType type: EventType) -> Observable<Event> {
        let dao = BusinessDAO()
        dao.objectId = business.objectId
        return dao.openEvent(type.rawValue)
            .mapToEventModel()
    }
    
    public func findByRadiusFromOrigin(origin: CLLocation, radius: Double, findMoreTrigger: Observable<Void>) -> Observable<[Business]> {
        
        let addressQuery = AddressDAO.typedQuery
        let centreGeoPoint = AVGeoPoint(latitude: origin.coordinate.latitude, longitude: origin.coordinate.longitude)
        addressQuery.whereKey(AddressDAO.Property.geoLocation, nearGeoPoint: centreGeoPoint)
        
        let businessQuery = createQuery()
        businessQuery.whereKey(BusinessDAO.Property.address, matchesQuery: addressQuery)
        
        return findWithPagination(businessQuery, findMoreTrigger: findMoreTrigger)
            .map { $0.map { $0.toBusiness() } }
    }
    
    private func createQuery() -> TypedAVQuery<BusinessDAO> {
        let query = BusinessDAO.typedQuery
        query.includeKey(BusinessDAO.Property.address)
        
        return query
    }
}
