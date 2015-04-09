//
//  EntityDAOMapper.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm

public class EntityDAOMapper {
    
    /**
    Save BusinessDAO to a designated Realm.
    
    :param: realm  The Realm.
    :param: daoArr Array of BusinessDAO to be saved to the Realm.
    */
    public func saveBusinessDaosToRealm(realm: RLMRealm, daoArr: [BusinessDAO]) {
        realm.beginWriteTransaction()
        for busDao in daoArr {
            Business.createOrUpdateInRealm(realm, withObject: toNSDictionary(busDao) { key, object, dict -> Void in
                switch(key) {
                    case "timeStart": dict.setObject(object["timeStart"].timeIntervalSince1970, forKey: "timeStart")
                    case "timeEnd": dict.setObject(object["timeEnd"].timeIntervalSince1970, forKey: "timeEnd")
                    case "geopoint":
                        dict.setObject(object["geopoint"].longitude, forKey: "longitude")
                        dict.setObject(object["geopoint"].latitude, forKey: "latitude")
                    default: dict.setObject(object[key], forKey: key)
                }
            })
        }
        realm.commitWriteTransaction()
    }
    
    /**
    Convert DAO to NSDictionary.
    
    :param: object The PFObject.
    :param: block  Special treatment for certain objects.
    
    :returns: The NSDictionary which contains the objects from PFObject.
    */
    private func toNSDictionary(object: PFObject, block: (String, PFObject, NSMutableDictionary) -> Void) -> NSDictionary {
        var dict = NSMutableDictionary()
        /// Parse fields
        dict.setObject(object.objectId, forKey: "objectId")
        dict.setObject(object.createdAt.timeIntervalSince1970, forKey: "remoteCreatedAt")
        dict.setObject(object.updatedAt.timeIntervalSince1970, forKey: "remoteUpdatedAt")
        
        for key in object.allKeys() {
            if let key = key as? String {
                block(key, object, dict)
            }
        }
        return dict
    }
}