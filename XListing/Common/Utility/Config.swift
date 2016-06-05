//
//  Config.swift
//  XListing
//
//  Created by Hong Zhu on 2016-02-05.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

final class Config {
    
    static func trackAppOpenedWithLaunchOptions(launchOptions: [NSObject : AnyObject]?) {
        
        if let launchOptions = launchOptions {
            AVAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        }
    }
    
    class func config() {
        
        configureLeanCloud()
    }
    
    private class func configureLeanCloud() {
        let id = "id"
        let key = "key"
        let dict = loadKeys(id, key)
        
        AVOSCloud.setLastModifyEnabled(true)
        AVOSCloud.setVerbosePolicy(kAVVerboseAuto)
        
        AVAnalytics.setAnalyticsEnabled(true)
        AVCloud.setProductionMode(true)
        #if DEBUG
            AVCloud.setProductionMode(false)
            AVAnalytics.setLogEnabled(true)
        #endif
        
        
        //        User.enableAutomaticUser()
        
        UserDAO.registerSubclass()
        EventDAO.registerSubclass()
        EventParticipationDAO.registerSubclass()
        AddressDAO.registerSubclass()
        BusinessDAO.registerSubclass()
        
        
        AVOSCloud.setApplicationId(dict[id], clientKey: dict[key])
    }
    
    private static func loadKeys(keys: String...) -> [String: String] {
        var result = [String: String]()
                
        let mode: String
        #if DEBUG
            mode = "dev"
        #else
            mode = "prod"
        #endif
        
        print("We are in \(mode.uppercaseString) mode!")
        
        let path = NSBundle.mainBundle().pathForResource("Parse", ofType: "plist")
        guard let dict = NSDictionary(contentsOfFile: path!) else {
            fatalError("Missing `Parse.plist` file which hosts keys for initializing the app. Please refer to instructions on how to setup the project.")
        }
        
        for key in keys {
            guard let modeDict: AnyObject = dict.objectForKey(mode), value = modeDict.objectForKey(key) as? String else {
                fatalError("Cannot find the key: \(key)")
            }
            result[key] = value
        }
        
        return result
    }
}