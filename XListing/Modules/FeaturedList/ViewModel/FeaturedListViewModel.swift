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
        setupRLMNotificationToken()
    }
    

    public func requestAllBusinesses() -> Task<Int, Void, NSError> {
        let task = Task<Int, Void, NSError> { progress, fulfill, reject, econfigure in
            /// Delete Realm db file for debug purpose only!!!
            let fileManager = NSFileManager.defaultManager()
            let path = RLMRealm.defaultRealmPath()
            fileManager.removeItemAtPath(path, error: nil)
            fileManager.removeItemAtPath(path + ".lock", error: nil)
            
            let businesses = BusinessDataManager().findBy().success { businesses -> Void in
                let realm = RLMRealm.defaultRealm()
                realm.beginWriteTransaction()
                for bus in businesses {
                    let b = Business()
                    
                    /// Parse fields
                    b.objectId = bus.objectId
                    b.createdAt = bus.createdAt.timeIntervalSince1970
                    b.updatedAt = bus.updatedAt.timeIntervalSince1970
                    
                    /// Business info
                    if let name = bus.nameSChinese {
                        b.nameSChinese = name
                    }
                    if let name = bus.nameTChinese {
                        b.nameTChinese = name
                    }
                    if let name = bus.nameEnglish {
                        b.nameEnglish = name
                    }
                    if let isClaimed = bus.isClaimed {
                        b.isClaimed = isClaimed
                    }
                    if let isClosed = bus.isClosed {
                        b.isClosed = isClosed
                    }
                    if let phone = bus.phone {
                        b.phone = phone
                    }
                    if let url = bus.url {
                        b.url = url
                    }
                    if let mobileUrl = bus.mobileUrl {
                        b.mobileUrl = mobileUrl
                    }
                    if let uid = bus.uid {
                        b.uid = uid
                    }
                    if let imageUrl = bus.imageUrl {
                        b.imageUrl = imageUrl
                    }
                    if let reviewCount = bus.reviewCount {
                        b.reviewCount = reviewCount
                    }
                    if let rating = bus.rating {
                        b.rating = rating
                    }
                    if let cover = bus.cover {
                        b.coverImageUrl = cover.url
                    }
                    
                    /// Featured
                    if let featured = bus.featured {
                        b.featured = featured
                    }
                    if let timeStart = bus.timeStart {
                        b.timeStart = timeStart.timeIntervalSince1970
                    }
                    if let timeEnd = bus.timeEnd {
                        b.timeEnd = timeEnd.timeIntervalSince1970
                    }
                    
                    /// Location
                    if let unit = bus.unit {
                        b.unit = unit
                    }
                    if let address = bus.address {
                        b.address = address
                    }
                    if let district = bus.district {
                        b.district = district
                    }
                    if let city = bus.city {
                        b.city = city
                    }
                    if let state = bus.state {
                        b.state = state
                    }
                    if let country = bus.country {
                        b.country = country
                    }
                    if let postalCode = bus.postalCode {
                        b.postalCode = postalCode
                    }
                    if let crossStreets = bus.crossStreets {
                        b.crossStreets = crossStreets
                    }
                    if let geopoint = bus.geopoint {
                        b.longitude = geopoint.longitude
                        b.latitude = geopoint.latitude
                    }
                    
                    Business.createOrUpdateInRealm(realm, withObject: b)
                    //                realm.beginWriteTransaction()
                    //                realm.addObject(b)
                    //                realm.commitWriteTransaction()
                    
                    //                let result = Business.allObjectsInRealm(realm)
                    //                println(result)
                }
                realm.commitWriteTransaction()
            }
        }
        
        return task
    }
}

extension FeaturedListViewModel {
    private func setupRLMNotificationToken() {
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
                        let t=cllocation!.distanceFromLocation(bus.cllocation)
                        let vm = BusinessViewModel(business: bus, distanceInMeter: cllocation!.distanceFromLocation(bus.cllocation))
                        //                    self.featured.append(vm)
                        
                        // apend BusinessViewModel to DynamicArray for React
                        self.dynamicArray.proxy.addObject(vm)
                    }
            }
            
        })
    }
}