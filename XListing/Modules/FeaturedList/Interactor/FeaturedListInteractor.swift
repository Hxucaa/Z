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
    
    private let listManager: FeaturedListDataManager
    private let locationManager: LocationDataManager
    
    init(featuredListDataManager: FeaturedListDataManager, locationDataManager: LocationDataManager) {
        listManager = featuredListDataManager
        locationManager = locationDataManager
    }
    
    func getFeaturedList() -> Task<Int, [BusinessDomain], NSError> {
        
        // acquire current location
        let currentLocationTask = locationManager.getCurrentGeoPoint()
        let resultTask = currentLocationTask.success { currentgp -> Task<Int, [BusinessDomain], NSError> in
            
            // retrieve a list of featured businesses
            let featuredBusinessesArrTask = self.listManager.findAListOfFeaturedBusinesses()
            let businessDomainConversionTask = featuredBusinessesArrTask.success { businessEntityArr -> [BusinessDomain] in
                
                // map to domain model
                let bdArr = businessEntityArr.map { be -> BusinessDomain in
                    var bd = BusinessDomain(be)
                    bd.distance = be.location?.geopoint?.distanceInKilometersTo(currentgp)
                    return bd
                }
                    
                return bdArr
            }
            
            return businessDomainConversionTask
        }
        
        return resultTask
    }
}

