//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public class FeaturedListViewModel : IFeaturedListViewModel {
    public let businessVMArr = DynamicArray()
    
    private let businessService: IBusinessService
    private let geoLocationService: IGeoLocationService
    
    public init(businessService: IBusinessService, geoLocationService: IGeoLocationService) {
        self.businessService = businessService
        self.geoLocationService = geoLocationService
    }
    
    
    public func getBusiness() {
        let query = BusinessDAO.query()!
        query.whereKey("featured", equalTo: true);
        //TODO: support for offline usage.
        //Fetch current location. Create BusinessViewModel with embedded distance data. And finally add the BusinessViewModels to dynamicArray for the view to consume the signal.
        geoLocationService.getCurrentLocation()
            .success { [unowned self] location -> Task<Int, Void, NSError> in
                return self.businessService.findBy(query)
                    .success { businessDAOArr -> Void in
                        for bus in businessDAOArr {
                            let vm: BusinessViewModel = BusinessViewModel(business: bus, currentLocation: location)
                            
//                            let vm = FeaturedListCellViewModel(business: bus)
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
//                            let vm = FeaturedListCellViewModel(business: bus)
                            // apend BusinessViewModel to DynamicArray for React
                            self.businessVMArr.proxy.addObject(vm)
                        }
                        
                }
        }
    }
    
    public func pushNearbyModule() {
        NSNotificationCenter.defaultCenter().postNotificationName(NavigationNotificationName.PushNearbyModule, object: nil)
    }
    
    public func pushDetailModule(section: Int) {
        let viewmodel = businessVMArr.proxy[section] as! BusinessViewModel
        
        NSNotificationCenter.defaultCenter().postNotificationName(NavigationNotificationName.PushDetailModule, object: nil, userInfo: ["viewmodel" : viewmodel])
    }
    
    public func pushProfileModule() {
        NSNotificationCenter.defaultCenter().postNotificationName(NavigationNotificationName.PushProfileModule, object: nil)
        
    }
}