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
    Migrate default Realm. Must call this function inside appDelegate application(application:didFinishLaunchingWithOptions:)
    */
    public class func migrateDefaultRealm() {
        // Notice setSchemaVersion is set to 1, this is always set manually. It must be higher than the previous version (oldSchemaVersion) or an RLMException is thrown
        RLMRealm.setSchemaVersion(1, forRealmAtPath: RLMRealm.defaultRealmPath(), withMigrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if oldSchemaVersion < 1 {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties and will update the schema on disk automatically
                
                
//                // The enumerateObjects:block: method iterates over every 'Business' object stored in the Realm file
//                migration.enumerateObjects(Business.className()) { oldObject, newObject in
//                    // combine name fields into a single field
//                    let firstName = oldObject["firstName"] as String
//                    let lastName = oldObject["lastName"] as String
//                    newObject["fullName"] = "\(firstName) \(lastName)"
//                }
            }
        })
        // now that we have called `setSchemaVersion:withMigrationBlock:`, opening an outdated
        // Realm will automatically perform the migration and opening the Realm will succeed
        // i.e. RLMRealm.defaultRealm()
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