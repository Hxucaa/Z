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
    
    // Class Name
    public class func parseClassName() -> String {
        return "_User"
    }
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged public var birthday: NSDate?
    
    @NSManaged public var nickname: String?
    
    @NSManaged public var profileImg: AVFile?
    
    @NSManaged public var profile: Profile
    
    @NSManaged public var latestLocation: PFGeoPoint?
}