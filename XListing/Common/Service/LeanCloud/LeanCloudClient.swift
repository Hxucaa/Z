//
//  ParseClient.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public final class LeanCloudClient {
    
    public static func trackAppOpenedWithLaunchOptions(launchOptions: [NSObject : AnyObject]) {
        
        AVAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    }
    
    public static func initialize() {
        prepareClient()
        loadKeys()
    }
    
    private static func prepareClient() {
        AVOSCloud.setLastModifyEnabled(true)
        AVOSCloud.setVerbosePolicy(kAVVerboseAuto)
        
        AVAnalytics.setAnalyticsEnabled(true)
        #if DEBUG
            AVAnalytics.setLogEnabled(true)
        #endif
        
        
//        User.enableAutomaticUser()
        
        User.registerSubclass()
        Me.registerSubclass()
        User_Business_Participation.registerSubclass()
        Address.registerSubclass()
        Business.registerSubclass()
    }
    
    private static func loadKeys() {
        var id: String?
        var key: String?
        
        let env = NSProcessInfo.processInfo().environment
        if let mode = env["exec_mode"] as String! {
            LSLogInfo("We are in \(mode.uppercaseString) mode!")
            
            let path = NSBundle.mainBundle().pathForResource("Parse", ofType: "plist")
            let dict: AnyObject = NSDictionary(contentsOfFile: path!)!
            
            if let modeDict: AnyObject = dict.objectForKey(mode) {
                id = modeDict.objectForKey("id") as? String
                key = modeDict.objectForKey("key") as? String
            }
            
        } else {

        }
        
        let errorMessage = "Unable to find Parse id and key for initialization"
        if let _id: String = id {
            if let _key: String = key {
                AVOSCloud.setApplicationId(_id, clientKey: _key)
            }
            else {
                LSLogError(errorMessage)
            }
        }
        else {
            LSLogError(errorMessage)
        }
    }
}