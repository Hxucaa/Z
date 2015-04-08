//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm
import SwiftTask
import ReactKit

public class FeaturedListViewModel : IFeaturedListViewModel {
    
//    public var featured: [BusinessViewModel] = []
    /// wrapper for an array of BusinessViewModel
    public let dynamicArray = DynamicArray()
    
    /// notification token from Realm
    private var token: RLMNotificationToken?
    /// location manager
    private var manager: OneShotLocationManager?
    
    public init() {
        // subscribes to notification from Realm
        token = RLMRealm.defaultRealm().addNotificationBlock( { [unowned self] note, realm -> Void in
            let task = Task<Int, CLLocation?, NSError> { progress, fulfill, reject, configure in
                // get current location
                self.manager = OneShotLocationManager()
                self.manager!.fetchWithCompletion { location, error in
                    self.manager = nil
                    if error == nil {
                        fulfill(location)
                    }
                    else {
                        reject(error!)
                    }
                }
            }
            .success { [unowned self] cllocation -> Void in
                // retrieve data from Realm
                let realm = RLMRealm.defaultRealm()
                let featuredArr = Business.objectsInRealm(realm, withPredicate: NSPredicate(format: "featured = %@", true))
                
                // process the data
                for item in featuredArr {
                    let bus = item as Business
                    
                    // initialize new BusinessViewModel
                    let vm = BusinessViewModel(business: bus, distance: cllocation!.distanceFromLocation(bus.cllocation))
//                    self.featured.append(vm)
                    
                    // apend BusinessViewModel to DynamicArray for React
                    self.dynamicArray.proxy.addObject(vm)
                }
            }
            
        })
        
        
    }

}