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

public final class BusinessRepository : _BaseRepository<Business, BusinessDAO>, IBusinessRepository {
    
    private let geolocationService: IGeoLocationService
    
    public init(geolocationService: IGeoLocationService) {
        self.geolocationService = geolocationService
    }
    
//    public func findByCurrentLocation() -> SignalProducer<[Business], NetworkError> {
//        return geolocationService.findCurrentLocation()
//            .flatMapError { error -> SignalProducer<CLLocation, NSError> in
//                
//                // TODO: A more generic handling of default location when location service fails
//                // TODO: Some kind of prompt for when location service is disabled
//                return SignalProducer<CLLocation, NSError>(value: CLLocation(latitude: 49.27623, longitude: -123.12941))
//            }
//        
//    }
    
    public func findByRadiusFromOrigin(origin: CLLocation, radius: Double, findMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[Business], NetworkError> {
        
        let addressQuery = AddressDAO.typedQuery
        let centreGeoPoint = AVGeoPoint(latitude: origin.coordinate.latitude, longitude: origin.coordinate.longitude)
        addressQuery.whereKey(AddressDAO.Property.geoLocation, nearGeoPoint: centreGeoPoint)
        
        let businessQuery = createQuery()
        businessQuery.whereKey(BusinessDAO.Property.address, matchesQuery: addressQuery)
        
        return findWithPagination(businessQuery, findMoreTrigger: findMoreTrigger)
    }
    
    public override func find(findMoreTrigger: SignalProducer<Void, NoError>) -> SignalProducer<[Business], NetworkError> {
        let query = createQuery()
        
        return findWithPagination(query, findMoreTrigger: findMoreTrigger)
    }
    
    private func createQuery() -> TypedAVQuery<BusinessDAO> {
        let query = BusinessDAO.typedQuery
        query.includeKey(BusinessDAO.Property.address)
        
        return query
    }
}
