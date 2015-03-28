//
//  Featured.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class FeaturedEntity: PFObject, PFSubclassing {
    
    
    // Starting time of featured business
    public var timeStart: NSDate? {
        get {
            return objectForKey("time_start") as? NSDate
        }
        set {
            setObject(newValue, forKey: "time_start")
        }
    }
    
    // Ending time of featured business
    public var timeEnd: NSDate? {
        get {
            return objectForKey("time_end") as? NSDate
        }
        set {
            setObject(newValue, forKey: "time_end")
        }
    }
    
    // Business
    public var business: BusinessEntity? {
        get {
            return self["business"] as? BusinessEntity
        }
        set {
            self["business"] = newValue
        }
    }
    
    // Class Name
    public class func parseClassName() -> String! {
        return "Featured"
    }
    
    // MARK: Constrcutros
    public override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}
