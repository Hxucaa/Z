//
//  UserDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

class UserDAO: AVUser {
    
    struct Property {
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
    
    func toString() -> String {
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
    override class func registerSubclass() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged var type: Int
    
    @NSManaged var status: Int
    
    @NSManaged var nickname: String
    @NSManaged var gender: Int
    @NSManaged var birthday: NSDate
    @NSManaged var ageGroup: Int
    @NSManaged var horoscope: Int
    @NSManaged var coverPhoto: AVFile?
    @NSManaged var whatsUp: String?
    @NSManaged var latestLocation: AVGeoPoint?
    @NSManaged var aaCount: Int
    @NSManaged var treatCount: Int
    @NSManaged var toGoCount: Int
    
    @NSManaged var address: AddressDAO?
}