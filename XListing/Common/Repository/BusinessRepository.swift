//
//  BusinessRepository.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import AVOSCloud

public protocol IBusinessRepository {
//    func startEvent(business: Business) -> SignalProducer
//    func cancelEvent(business: Business) -> SignalProducer
//    func completeEvent(business: Business) -> SignalProducer
    func openEvent(business: Business, eventType type: EventType) -> SignalProducer<Event, NetworkError>
    func findByCurrentLocation(findMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[Business], NetworkError>
    func findByRadiusFromOrigin(origin: CLLocation, radius: Double, findMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[Business], NetworkError>
}

public final class BusinessRepository : _BaseRepository<Business, BusinessDAO>, IBusinessRepository {
    
    private let geolocationService: IGeoLocationService
    
    public init(geolocationService: IGeoLocationService) {
        self.geolocationService = geolocationService
        
        super.init(daoToModelMapper: { $0.toBusiness() })
    }
    
    
    
    public func findByCurrentLocation(findMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[Business], NetworkError> {
        return geolocationService.getCurrentLocation()
            .flatMapError { error -> SignalProducer<CLLocation, NetworkError> in
                
                // TODO: A more generic handling of default location when location service fails
                // TODO: Some kind of prompt for when location service is disabled
                return SignalProducer<CLLocation, NetworkError>(value: CLLocation(latitude: 49.27623, longitude: -123.12941))
            }
            // TODO: Extract constant number away
            .flatMap(.Latest) {
                self.findByRadiusFromOrigin($0, radius: 1000 * 10, findMoreTrigger: findMoreTrigger)
        }
        
    }
    
    public func openEvent(business: Business, eventType type: EventType) -> SignalProducer<Event, NetworkError> {
        let dao = BusinessDAO()
        dao.objectId = business.objectId
        return dao.openEvent(type.rawValue)
            .mapToEventModel()
    }
    
    public func findByRadiusFromOrigin(origin: CLLocation, radius: Double, findMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[Business], NetworkError> {
        
        let addressQuery = AddressDAO.typedQuery
        let centreGeoPoint = AVGeoPoint(latitude: origin.coordinate.latitude, longitude: origin.coordinate.longitude)
        addressQuery.whereKey(AddressDAO.Property.geoLocation, nearGeoPoint: centreGeoPoint)
        
        let businessQuery = createQuery()
        businessQuery.whereKey(BusinessDAO.Property.address, matchesQuery: addressQuery)
        
        return findWithPagination(businessQuery, findMoreTrigger: findMoreTrigger)
    }
    
    private func createQuery() -> TypedAVQuery<BusinessDAO> {
        let query = BusinessDAO.typedQuery
        query.includeKey(BusinessDAO.Property.address)
        
        return query
    }
}
