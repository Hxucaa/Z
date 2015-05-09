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
    private let geoLocationService: IGeoLocationService
    
    public init(businessService: IBusinessService, geoLocationService: IGeoLocationService) {
        self.businessService = businessService
        self.geoLocationService = geoLocationService
    }
    
    
    public func getBusiness(query: PFQuery) -> Task<Int, Void, NSError> {
        //TODO: support for offline usage.
        //Fetch current location. Create BusinessViewModel with embedded distance data. And finally add the BusinessViewModels to dynamicArray for the view to consume the signal.
        return getCurrentLocation()
            .success { [unowned self] location -> Task<Int, Void, NSError> in
                return self.businessService.findBy(query)
                    .success { businessDAOArr -> Void in
                        for bus in businessDAOArr {
                            let vm: BusinessViewModel = BusinessViewModel(business: bus, currentLocation: location)
                            // apend BusinessViewModel to DynamicArray for React
                            self.businessVMArr.proxy.addObject(vm)
                        }
                        
                }
            }
            .failure { (error: NSError?, isCancelled: Bool) -> Void in
                return self.businessService.findBy(query)
                    .success { businessDAOArr -> Void in
                        for bus in businessDAOArr {
                            let vm: BusinessViewModel = BusinessViewModel(business: bus)
                            // apend BusinessViewModel to DynamicArray for React
                            self.businessVMArr.proxy.addObject(vm)
                        }
                        
                }
            }
    }
    
    
    public func getCurrentLocation() -> Task<Int, CLLocation, NSError> {
        return geoLocationService.getCurrentLocation()
    }
}
