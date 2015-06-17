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
    
    public enum Property : String {
        case Birthday = "birthday"
        case NickName = "nickname"
        case ProfileImg = "profileImg"
        case Profile = "profile"
        case LatestLocation = "latestLocation"
    }
//    
    // Class Name
//    public class func parseClassName() -> String {
//        return "_User"
//    }
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged public var birthday: NSDate?
//    public var birthday: NSDate? {
//        get {
//            return self[Property.Birthday.rawValue] as? NSDate
//        }
//        set {
//            self[Property.Birthday.rawValue] = newValue
//        }
//    }
    
    @NSManaged public var nickname: String?
//    public var nickname: String? {
//        get {
//            return self[Property.NickName.rawValue] as? String
//        }
//        set {
//            self[Property.NickName.rawValue] = newValue
//        }
//    }

    @NSManaged public var profileImg: AVFile?
//    public var profileImg: AVFile? {
//        get {
//            return self[Property.ProfileImg.rawValue] as? AVFile
//        }
//        set {
//            self[Property.ProfileImg.rawValue] = newValue
//        }
//    }
    
    @NSManaged public var profile: Profile
//    public var profile: Profile {
//        get {
//            return self[Property.Profile.rawValue] as! Profile
//        }
//        set {
//            self[Property.Profile.rawValue] = newValue
//        }
//    }
    
    @NSManaged public var latestLocation: AVGeoPoint?
//    public var latestLocation: AVGeoPoint? {
//        get {
//            return self[Property.LatestLocation.rawValue] as? AVGeoPoint
//        }
//        set {
//            self[Property.LatestLocation.rawValue] = newValue
//        }
//    }
}