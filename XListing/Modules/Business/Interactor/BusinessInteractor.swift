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
    private let geolocationDataManager: GeolocationDataManager
    private let businessDataManager: BusinessDataManager
    
    public init(businessDataManager: BusinessDataManager, geolocationDataManager: GeolocationDataManager) {
        self.businessDataManager = businessDataManager
        self.geolocationDataManager = geolocationDataManager
    }
    
    ///
    ///
    ///
    ///
    public func saveBusiness(business: BusinessEntity) -> Task<Int, Bool, NSError> {
        let task = businessDataManager.save(business)
        
        return task
    }
    
    public func findBusinessesBy(query: PFQuery) -> Task<Int, [BusinessDomain], NSError> {
        // acquire current location
        let currentLocationTask = geolocationDataManager.getCurrentGeoPoint()
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