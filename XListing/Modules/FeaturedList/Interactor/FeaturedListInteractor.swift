//
//  FeaturedListInteractor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

class FeaturedListInteractor : IFeaturedListInteractor {
    
    private let featuredListDataManager: IFeaturedListDataManager
    private let locationDataManager: ILocationDataManager
    
    init(featuredListDataManager: IFeaturedListDataManager, locationDataManager: ILocationDataManager) {
        self.featuredListDataManager = featuredListDataManager
        self.locationDataManager = locationDataManager
    }
    
    func getFeaturedList() -> Task<Int, [BusinessDomain], NSError> {
        
        // acquire current location
        let currentLocationTask = locationDataManager.getCurrentGeoPoint()
        let resultTask = currentLocationTask.success { currentgp -> Task<Int, [BusinessDomain], NSError> in
            
            // retrieve a list of featured businesses
            let featuredBusinessesArrTask = self.featuredListDataManager.findAListOfFeaturedBusinesses()
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

