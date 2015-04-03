//
//  BusinessInteractor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class BusinessInteractor : IBusinessInteractor {
    private let locationDataManager: LocationDataManager
    private let businessDataManager: BusinessDataManager
    
    public init(businessDataManager: BusinessDataManager, locationDataManager: LocationDataManager) {
        self.businessDataManager = businessDataManager
        self.locationDataManager = locationDataManager
    }
    
    ///
    ///
    ///
    ///
    public func saveBusiness(business: BusinessEntity) -> Task<Int, Bool, NSError> {
        let addressString = business.location!.completeAddress
        let forwardGeocodingTask = LocationDataManager().forwardGeocoding(addressString)
        
        let resultTask = forwardGeocodingTask
            .success { (geopoint) -> Task<Int, Bool, NSError> in
                business.location?.geopoint = geopoint
                
                return self.businessDataManager.save(business)
            }
            .failure { (error: NSError?, isCancelled: Bool) -> Bool in
                if let error = error {
                    println("Forward geocoding failed with error: \(error.localizedDescription)")
                }
                if isCancelled {
                    println("Forward geocoding cancelled")
                }
                return false
        }
        
        return resultTask
    }
    
    public func findBusinessesBy(query: PFQuery) -> Task<Int, [BusinessDomain], NSError> {
        // acquire current location
        let currentLocationTask = locationDataManager.getCurrentGeoPoint()
        let resultTask = currentLocationTask.success { currentgp -> Task<Int, [BusinessDomain], NSError> in
            
            // retrieve a list of featured businesses
            let businessesTask = self.businessDataManager.findBy(query)
            let businessDomainConversionTask = businessesTask.success { businessEntityArr -> [BusinessDomain] in
                
                // map to domain model
                let businessDomainArr = businessEntityArr.map { businessEntity -> BusinessDomain in
                    let distance = businessEntity.location?.geopoint?.distanceInKilometersTo(currentgp)
                    let businessDomain = BusinessDomain(businessEntity, distance: distance)
                    return businessDomain
                }
                
                return businessDomainArr
            }
            
            return businessDomainConversionTask
        }
        return resultTask
    }
    
//    public func setBusinessAsFeatured(toBeFeatured: FeaturedDomain) -> Task<Int, Bool, NSError> {
//        let task = FeaturedBusinessDataManager().save(toBeFeatured.toEntity())
//        
//        return task
//    }
}