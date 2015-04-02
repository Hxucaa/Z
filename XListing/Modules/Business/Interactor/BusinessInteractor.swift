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
    private let locationDataManager: ILocationDataManager
    private let businessDataManager: IBusinessDataManager
    
    public init(businessDataManager: IBusinessDataManager, locationDataManager: ILocationDataManager) {
        self.businessDataManager = businessDataManager
        self.locationDataManager = locationDataManager
    }
    
    public func saveBusiness(business: BusinessEntity) -> Task<Int, Bool, NSError> {
        let addressString = business.location!.completeAddress
        let forwardGeocodingTask = LocationDataManager().forwardGeocoding(addressString)
        
        let resultTask = forwardGeocodingTask
            .success { (geopoint) -> Task<Int, Bool, NSError> in
                business.location?.geopoint = geopoint
                
                return BusinessDataManager().save(business)
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
    
}