//
//  UserDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public class User: AVUser {
    
    public struct Property {
        static let type = "type"
        static let status = "status"
        static let isActive = "isActive"
        static let nickName = "nickname"
        static let gender = "gender"
        static let ageGroup = "ageGroup"
        static let horoscope = "horoscope"
        static let address = "address"
        static let coverPhoto = "coverPhoto"
        static let whatsUp = "whatsUp"
        static let latestLocation = "latestLocation"
        static let aaCount = "aaCount"
        static let treatCount = "treatCount"
        static let toGoCount = "toGoCount"
    }
    
    public func toString() -> String {
        var s = ""
        s += "NickName: \(self[Property.nickName])"
        s += "Gender: \(self[Property.gender])"
        s += "AgeGroup: \(self[Property.ageGroup])"
        s += "Horoscope: \(self[Property.horoscope])"
        return s
    }
    
    // Class Name
//    public class func parseClassName() -> String {
//        return "_User"
//    }
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    public var type: UserType {
        get {
            return UserType(rawValue: self[Property.type] as! Int)!
        }
    }
    
    public var status: UserStatus {
        get {
            return UserStatus(rawValue: self[Property.status] as! Int)!
        }
    }
    
    public var isActive: Activation {
        get {
            return Activation(self[Property.isActive] as! Bool)
        }
    }
    
    @NSManaged public var nickname: String
    
    public var gender: Gender {
        get {
            return Gender(rawValue: self[Property.gender] as! Int)!
        }
    }
    
    public var ageGroup: AgeGroup {
        get {
            return AgeGroup(rawValue: self[Property.ageGroup] as! Int)!
        }
    }
    
    public var horoscope: Horoscope {
        get {
            return Horoscope(rawValue: self[Property.horoscope] as! Int)!
        }
    }
    
    public var coverPhoto: ImageFile? {
        get {
            if let file = (self[Property.coverPhoto] as? AVFile) {
                return ImageFile(name: file.name, url: file.url)
            }
            else {
                return nil
            }
        }
    }
    
    @NSManaged public var whatsUp: String?
    
    public var latestLocation: Geolocation? {
        get {
            guard let geopoint = self[Property.latestLocation] as? AVGeoPoint else {
                return nil
            }
            return Geolocation(latitude: geopoint.latitude, longitude: geopoint.longitude)
        }
    }
    
    @NSManaged public var aaCount: Int
    
    @NSManaged public var treatCount: Int
    
    @NSManaged public var toGoCount: Int
}