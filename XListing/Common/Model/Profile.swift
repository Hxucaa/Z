//
//  Profile.swift
//  XListing
//
//  Created by William Qi on 2015-05-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public class Profile: AVObject, AVSubclassing {
    
    // Class Name
    public func parseClassName() -> String! {
        return "Profile"
    }
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged public var nickname: String?
}
