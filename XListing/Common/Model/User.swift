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
        case LatestGeolocation = "latestLocation"
        case Gender = "gender"
        case Horoscope = "horoscope"
        case AgeGroup = "ageGroup"
    }
    
    public func toString() -> String{
        var s = ""
        s += "birthday: \(self[Property.Birthday.rawValue])"
        s += "NickName: \(self[Property.NickName.rawValue])"
        s += "Gender: \(self[Property.Gender.rawValue])"
        s += "AgeGroup: \(self[Property.AgeGroup.rawValue])"
        s += "Horoscope: \(self[Property.Horoscope.rawValue])"
        return s
    }
    
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
    
    @NSManaged public var nickname: String?
    
    @NSManaged private var profileImg: AVFile?
    public var profileImg_: ImageFile? {
        get {
            if let url = profileImg?.url {
                return ImageFile(url: url)
            }
            else {
                return nil
            }
        }
        set {
            if let newValue = newValue {
                profileImg = AVFile(name: newValue.name, data: newValue.data)
            }
        }
    }
    
    @NSManaged public var profile: Profile
    
    @NSManaged private var latestLocation: AVGeoPoint?
    public var latestGeolocation: Geolocation? {
        get {
            if let latestLocation = latestLocation {
                return Geolocation(latitude: latestLocation.latitude, longitude: latestLocation.longitude)
            }
            return nil
        }
        set {
            if let newValue = newValue {
                latestLocation = AVGeoPoint(latitude: newValue.latitude, longitude: newValue.longitude)
            }
        }
    }
    
    @NSManaged private var gender: Bool
    public var gender_: Gender {
        get {
            return gender ? Gender.Male : Gender.Female
        }
        set {
            gender = newValue.dbRepresentation
        }
    }
    
    @NSManaged private var horoscope: Int
    public var horoscope_: Horoscope? {
        get {
            return Horoscope(rawValue: horoscope)
        }
    }
    
    @NSManaged private var ageGroup: Int
    public var ageGroup_: AgeGroup? {
        get {
            return AgeGroup(rawValue: ageGroup)
        }
    }
    
    @NSManaged public var status: String?
}