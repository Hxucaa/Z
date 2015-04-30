//
//  ParseClient.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class ParseClient {
    
    public class func initializeClient() {
        prepareClient()
        initialize()
    }
    
    private class func prepareClient() {
        Parse.enableLocalDatastore()
        UserDAO.enableAutomaticUser()
        UserDAO.initialize()
        BusinessDAO.initialize()
        WantToGoDAO.initialize()
    }
    
    private class func initialize() {
        var id: String?
        var key: String?
        
        let env = NSProcessInfo.processInfo().environment
        if let mode = env["exec_mode"] as? String {
            println("We are in \(mode.uppercaseString) mode!")
            
            let path = NSBundle.mainBundle().pathForResource("Parse", ofType: "plist")
            let dict: AnyObject = NSDictionary(contentsOfFile: path!)!
            
            if let modeDict: AnyObject = dict.objectForKey(mode) {
                id = modeDict.objectForKey("id") as? String
                key = modeDict.objectForKey("key") as? String
            }
            
        } else {
            // If exec_mode is not present in environment variables, then possibly the app is released in app store. In that case environment variables may not be passed to the app. This requires further investigation
            // TODO: investigate passing environment variables in app release
            // TODO: fill in release id and key if needed
            //            id = "";
            //            key = "";
        }
        
        let errorMessage = "Unable to find Parse id and key for initialization"
        if let _id: String = id {
            if let _key: String = key {
                Parse.setApplicationId(_id, clientKey: _key)
            }
            else {
                println(errorMessage)
            }
        }
        else {
            println(errorMessage)
        }
    }
}