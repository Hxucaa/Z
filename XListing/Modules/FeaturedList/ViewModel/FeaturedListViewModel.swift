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
    
    private var dm: IDataManager
    
    private var realmService: IRealmService
    
    /// Lazily evaluated list of featured businesses
    private var featured = Business.objectsInRealm(RealmService().defaultRealm, withPredicate: NSPredicate(format: "featured = %@", true))
    
    /// notification token from Realm
    private var token: RLMNotificationToken?
    
    /// wrapper for an array of BusinessViewModel
    public let businessVMArr = DynamicArray()

    public init(datamanager: IDataManager, realmService: IRealmService) {
        dm = datamanager
        self.realmService = realmService
        
//        setupRLMNotificationToken()
    }
    

    public func requestAllBusinesses() {
        //TODO: support for offline usage.
//        return dm.getFeaturedBusiness()
        prepareDataForSignal()
    }
}

extension FeaturedListViewModel {
    /**
    Subscribe to Realm notification.
    */
    private func setupRLMNotificationToken() {
        // subscribes to notification from Realm
        token = RLMRealm.defaultRealm().addNotificationBlock( { [unowned self] note, realm -> Void in
            self.prepareDataForSignal()
        })
    }
    
    /**
    Fetch current location. Create BusinessViewModel with embedded distance data. And finally add the BusinessViewModels to dynamicArray for the view to consume the signal.
    */
    private func prepareDataForSignal() {
        let task = Task<Int, CLLocation?, NSError> { [unowned self] progress, fulfill, reject, configure in
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
        .success { [unowned self] cllocation -> Void in
            
            self.addToBusinessVMArr(cllocation!)
        }
    }
    
    private func addToBusinessVMArr(cllocation: CLLocation) {
        for item in self.featured {
            let bus = item as! Business
            
            // initialize new BusinessViewModel
            let t = cllocation.distanceFromLocation(bus.cllocation)
            let vm = BusinessViewModel(business: bus, distanceInMeter: cllocation.distanceFromLocation(bus.cllocation))
            
            // apend BusinessViewModel to DynamicArray for React
            self.businessVMArr.proxy.addObject(vm)
        }
    }
}