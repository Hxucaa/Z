//
//  BaseViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm
import SwiftTask
import ReactKit

public class BaseViewModel {
    
    private var dm: IDataManager
    
    private var realmService: IRealmService
    
    /// Lazily evaluated list of featured businesses
    private var businesses = Business.allObjects()
    
    /// notification token from Realm
    private var token: RLMNotificationToken?
    
    /// wrapper for an array of BusinessViewModel
    public let businessVMArr = DynamicArray()
    
    public init(datamanager: IDataManager, realmService: IRealmService) {
        dm = datamanager
        self.realmService = realmService
        
        //        setupRLMNotificationToken()
    }
    
    
    public func getBusiness() {
        //TODO: support for offline usage.
        //        return dm.getFeaturedBusiness()
        prepareDataForSignal(businesses)
    }
    
    
    /**
    Subscribe to Realm notification.
    */
    public func setupRLMNotificationToken(results: RLMResults) {
        // subscribes to notification from Realm
        token = RLMRealm.defaultRealm().addNotificationBlock( { [unowned self] note, realm -> Void in
            self.prepareDataForSignal(results)
        })
    }
    
    /**
    Fetch current location. Create BusinessViewModel with embedded distance data. And finally add the BusinessViewModels to dynamicArray for the view to consume the signal.
    */
    public func prepareDataForSignal(results: RLMResults) {
        // add BusinessViewModel to the dynamic array for signal consumption by view
        let addToBusinessVMArr = { (cllocation: CLLocation?) -> Void in
            for item in results {
                let bus = item as! Business
                
                // initialize new BusinessViewModel
                var vm: BusinessViewModel
                if let loc = cllocation {
                    vm = BusinessViewModel(business: bus, distanceInMeter: loc.distanceFromLocation(bus.cllocation))
                }
                else {
                    vm = BusinessViewModel(business: bus)
                }
                
                // apend BusinessViewModel to DynamicArray for React
                self.businessVMArr.proxy.addObject(vm)
            }
            
        }
        
        let task = getCurrentLocation()
            .success { [unowned self] cllocation -> Void in
                // with current location
                addToBusinessVMArr(cllocation)
            }
            .failure { [unowned self] error, isCancelled -> Void in
                // no current location
                addToBusinessVMArr(nil)
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
