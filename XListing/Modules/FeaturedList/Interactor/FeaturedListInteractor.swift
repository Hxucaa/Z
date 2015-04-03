//
//  FeaturedListInteractor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class FeaturedListInteractor : IFeaturedListInteractor {
    
    private let businessDataManager: BusinessDataManager
    private let geolocationDataManager: GeolocationDataManager
    
    public init(businessDataManager: BusinessDataManager, geolocationDataManager: GeolocationDataManager) {
        self.businessDataManager = businessDataManager
        self.geolocationDataManager = geolocationDataManager
    }
    
    public func getFeaturedList() -> Task<Int, [BusinessDomain], NSError> {
        
        // acquire current location
        let currentLocationTask = geolocationDataManager.getCurrentGeoPoint()
        let resultTask = currentLocationTask.success { currentgp -> Task<Int, [BusinessDomain], NSError> in
            
            // retrieve a list of featured businesses
            let query = BusinessEntity.query()
            query.whereKey("featured", equalTo: true)
            let featuredBusinessesArrTask = self.businessDataManager.findBy(query)
            let businessDomainConversionTask = featuredBusinessesArrTask.success { businessEntityArr -> [BusinessDomain] in
                
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
}

