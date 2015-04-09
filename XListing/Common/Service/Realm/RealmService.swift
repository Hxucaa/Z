//
//  RealmService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm

public class RealmService {
    /// Default Realm
    public let defaultRealm = RLMRealm.defaultRealm()
    
    /**
    WARNING: This method bypasses Realm database migration which can lead to corrupt and inconsistent databases. Only use this method if you know what you are doing.
    */
    public func deleteDefaultRealm() -> Void {
        deleteARealm(defaultRealm)
    }
    
    /**
    Delete a realm from the device.
    
    :param: realm A specific Realm.
    */
    private func deleteARealm(realm: RLMRealm) -> Void {
        println("WARNING: Deletion of Realm bypasses database migration which can lead to corrupt and inconsistent databases. Only use this method if you know what you are doing.")
        let fileManager = NSFileManager.defaultManager()
        let path = realm.path
        fileManager.removeItemAtPath(path, error: nil)
        fileManager.removeItemAtPath(path + ".lock", error: nil)
    }
    
    /// Create singleton
    class var sharedInstance : RealmService {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : RealmService? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = RealmService()
        }
        return Static.instance!
    }
}