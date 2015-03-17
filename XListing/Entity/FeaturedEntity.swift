//
//  Featured.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class FeaturedEntity: PFObject, PFSubclassing {
    
    
    // Starting time of featured business
    var timeStart: NSDate {
        get {
            return objectForKey("time_start") as NSDate
        }
        set {
            setObject(newValue, forKey: "time_start")
        }
    }
    
    // Ending time of featured business
    var timeEnd: NSDate {
        get {
            return objectForKey("time_end") as NSDate
        }
        set {
            setObject(newValue, forKey: "time_end")
        }
    }
    
    // Business
    var business: BusinessEntity {
        get {
            return self["business"] as BusinessEntity
        }
        set {
            self["business"] = newValue
        }
    }
    
    // Class Name
    class func parseClassName() -> String! {
        return "Featured"
    }
    
    // MARK: Constrcutros
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}
