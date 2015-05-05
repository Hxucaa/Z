//
//  BaseViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public class BaseViewModel {
    
    /// wrapper for an array of BusinessViewModel
    public let businessVMArr = DynamicArray()
    
    private let businessService: IBusinessService
    
    public init(businessService: IBusinessService) {
        self.businessService = businessService
        //        setupRLMNotificationToken()
    }
    
    
    public func getBusiness() {
        //TODO: support for offline usage.
        //        return dm.getFeaturedBusiness()
        prepareDataForSignal()
    }
    
    
    /**
    Fetch current location. Create BusinessViewModel with embedded distance data. And finally add the BusinessViewModels to dynamicArray for the view to consume the signal.
    */
    public func prepareDataForSignal() {
        
        getCurrentLocation()
            .success { [unowned self] location -> Task<Int, Void, NSError> in
                return self.businessService.findBy(BusinessDAO.query())
                    .success { businessDAOArr -> Void in
                        for bus in businessDAOArr {
                            let vm: BusinessViewModel = BusinessViewModel(business: bus, currentLocation: location)
                            // apend BusinessViewModel to DynamicArray for React
                            self.businessVMArr.proxy.addObject(vm)
                        }
                        
                    }
            }
    }
    
    public func getCurrentLocation() -> Task<Int, CLLocation, NSError> {
        let task = Task<Int, CLLocation, NSError> { [unowned self] progress, fulfill, reject, configure in
            // get current location
            PFGeoPoint.geoPointForCurrentLocationInBackground({ (geopoint, error) -> Void in
                if error == nil {
                    let t = geopoint!
                    fulfill(CLLocation(latitude: t.latitude, longitude: t.longitude))
                }
                else {
                    reject(error!)
                }
            })
        }
        
        return task
    }
}
