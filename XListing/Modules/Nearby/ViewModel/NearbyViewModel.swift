//
//  NearbyViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit
import MapKit

public class NearbyViewModel : INearbyViewModel {
    public let businessDynamicArr = DynamicArray()
    
    private let businessService: IBusinessService
    private let geoLocationService: IGeoLocationService
    
    private var businessModelArr: [Business]!
    
    public init(businessService: IBusinessService, geoLocationService: IGeoLocationService) {
        self.businessService = businessService
        self.geoLocationService = geoLocationService
    }
    
    public func getBusiness() -> Stream<Void> {
        let query = Business.query()!
        
        //TODO: support for offline usage.
        //Fetch current location. Create BusinessViewModel with embedded distance data. And finally add the BusinessViewModels to dynamicArray for the view to consume the signal.
        let task = geoLocationService.getCurrentGeoPoint()
            .success { [unowned self] geopoint -> Task<Int, Void, NSError> in
                query.whereKey("geopoint", nearGeoPoint: geopoint)
                return self.businessService.findBy(query)
                    .success { businessDAOArr -> Void in
                        self.businessModelArr = businessDAOArr
                        
                        for bus in businessDAOArr {
                            let vm = NearbyHorizontalScrollCellViewModel(business: bus, currentLocation: CLLocation(latitude: geopoint.latitude, longitude: geopoint.longitude))
                            // apend BusinessViewModel to DynamicArray for React
                            self.businessDynamicArr.proxy.addObject(vm)
                        }
                        
                }
            }
//            .failure { (error, isCancelled) -> Void in
//                query.whereKey("geopoint", nearGeoPoint: self.geoLocationService.defaultGeoPoint)
//                return self.businessService.findBy(query)
//                    .success { businessDAOArr -> Void in
//                        self.businessModelArr = businessDAOArr
//                        
//                        for bus in businessDAOArr {
//                            let vm = NearbyHorizontalScrollCellViewModel(business: bus)
//                            self.businessDynamicArr.proxy.addObject(vm)
//                        }
//                        return
//                    }
//            }
        return Stream<Void>.fromTask(task)
    }
    
    /**
    Navigate to Detail Module.
    
    :param: businessViewModel The business information to pass along.
    */
    public func pushDetailModule(section: Int) {
        let model: AnyObject = businessModelArr[section]
        
        NSNotificationCenter.defaultCenter().postNotificationName(NavigationNotificationName.PushDetailModule, object: nil, userInfo: ["BusinessModel" : model])
    }
    
    /**
    Get current geo location. If location service fails for any reason, use hardcoded geo location instead.
    
    :returns: A Task that contains a geo location.
    */
    public func getCurrentLocation() -> Stream<CLLocation> {
        return Stream<CLLocation>.fromTask(geoLocationService.getCurrentLocation().failure { [unowned self] (error, isCancelled) -> CLLocation in
                // with hardcoded location
                //TODO: better support for hardcoded location
                println("Location service failed! Using default Vancouver location.")
                return CLLocation(latitude: 49.27623, longitude: -123.12941)
            }
        )
    }
    
    public func pushProfileModule() {
        NSNotificationCenter.defaultCenter().postNotificationName(NavigationNotificationName.PushProfileModule, object: nil)
        
    }
}