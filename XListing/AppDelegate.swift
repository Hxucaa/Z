//
//  AppDelegate.swift
//  XListing
//
//  Created by Lance on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import Realm

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    private let appDependencies = AppDependencies()

    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // must register subclasses before connecting to Parse
        ParseClient.registerSubclasses()
        // connect to Parse
        ParseClient.initializeClient()
        
        // initialize root view
        appDependencies.installRootViewControllerIntoWindow(window!)
        
//        PopulateParse().populate()
//        PopulateParse().featuredizeByNameSChinese("海港")
        
        populateRealm()
        return true
    }

    public func populateRealm() {
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
    
    public func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    public func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    public func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    public func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    public func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

