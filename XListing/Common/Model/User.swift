//
//  UserDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public final class User: AVUser, AVSubclassing {
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged public var birthday: NSDate?
//    public dynamic var birthday: NSDate? {
//        get {
//            return objectForKey("birthday") as? NSDate
//        }
//        set {
//            setObject(newValue, forKey: "birthday")
//        }
//    }
    @NSManaged public var nickname: String?
}