//
//  WantToGoDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-25.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class WantToGoDAO: PFObject, PFSubclassing {
    
    // Class Name
    public class func parseClassName() -> String {
        return "WantToGo"
    }
    
    // MARK: Constrcutros
    public override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(createdBy: UserDAO, interestedIn: BusinessDAO, startTime: NSDate, endTime: NSDate) {
        self.init()
        self.createdBy = createdBy
        self.interestedIn = interestedIn
        self.startTime = startTime
        self.endTime = endTime
    }
    
    public var createdBy: UserDAO {
        get {
            return self["createdBy"] as! UserDAO
        }
        set {
            self["createdBy"] = newValue
        }
    }
    
    public var interestedIn: BusinessDAO {
        get {
            return self["interestedIn"] as! BusinessDAO
        }
        set {
            self["interestedIn"] = newValue
        }
    }
    
    public var startTime: NSDate {
        get {
            return self["startTime"] as! NSDate
        }
        set {
            self["startTime"] = newValue
        }
    }
    
    public var endTime: NSDate {
        get {
            return self["endTime"] as! NSDate
        }
        set {
            self["endTime"] = newValue
        }
    }
}