//
//  Profile.swift
//  XListing
//
//  Created by William Qi on 2015-05-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public final class Profile: AVObject, AVSubclassing {
    
    public enum Property : String {
        case Nickname = "nickname"
        case ProfileImg = "profileImg"
    }
    
    public override init() {
        super.init()
    }
    
    // Class Name
    public class func parseClassName() -> String! {
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
//    public var nickname: String? {
//        get {
//            return self.objectForKey("nickname") as? String
//        }
//        set {
//            self.setObject(newValue, forKey: "nickname")
//        }
//    }
    
    @NSManaged public var profileImg: AVFile?
//    public var profileImg: AVFile? {
//        get {
//            return self.objectForKey("profileImg") as? AVFile
//        }
//        set {
//            self.setObject(newValue, forKey: "profileImg")
//        }
//    }
}