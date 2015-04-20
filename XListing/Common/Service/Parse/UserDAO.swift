//
//  UserDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class UserDAO: PFUser, PFSubclassing {
    
    public var name: String? {
        get {
            return self["name"] as? String
        }
        set {
            self["name"] = newValue
        }
    }
    
    // MARK: Constrcutros
    public override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}