//
//  WantToGoDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-25.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public final class WantToGo: PFObject, PFSubclassing {
    
    // Class Name
    public class func parseClassName() -> String {
        return "WantToGo"
    }
    
    // MARK: Constrcutros
    public override class func registerSubclass() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    public init(createdBy: User, interestedIn: Business, startTime: NSDate, endTime: NSDate) {
        self.createdBy = createdBy
        self.interestedIn = interestedIn
        self.startTime = startTime
        self.endTime = endTime
        super.init()
    }
    
    public dynamic var createdBy: User
    
    public dynamic var interestedIn: Business
    
    public dynamic var startTime: NSDate
    
    public dynamic var endTime: NSDate
}