//
//  UserDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud
import ReactiveCocoa

public class UserDAO: AVUser {
    
//    struct Property {
//        static let type = "type"
//        static let status = "status"
//        static let isActive = "isActive"
//        static let nickName = "nickname"
//        static let gender = "gender"
//        static let ageGroup = "ageGroup"
//        static let horoscope = "horoscope"
//        static let address = "address"
//        static let coverPhoto = "coverPhoto"
//        static let whatsUp = "whatsUp"
//        static let latestLocation = "latestLocation"
//        static let aaCount = "aaCount"
//        static let treatCount = "treatCount"
//        static let toGoCount = "toGoCount"
//    }
    
//    func toString() -> String {
//        var s = ""
//        s += "NickName: \(self[Property.nickName])"
//        s += "Gender: \(self[Property.gender])"
//        s += "AgeGroup: \(self[Property.ageGroup])"
//        s += "Horoscope: \(self[Property.horoscope])"
//        return s
//    }
    
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
    
//    @NSManaged var type: Int
//    
//    @NSManaged var status: Int
//    
//    @NSManaged var nickname: String
//    @NSManaged var gender: Int
//    @NSManaged var birthday: NSDate
//    @NSManaged var ageGroup: Int
//    @NSManaged var horoscope: Int
//    @NSManaged var coverPhoto: AVFile?
//    @NSManaged var whatsUp: String?
//    @NSManaged var latestLocation: AVGeoPoint?
//    @NSManaged var aaCount: Int
//    @NSManaged var treatCount: Int
//    @NSManaged var toGoCount: Int
//    
//    @NSManaged var address: AddressDAO?
    
    override init() {
        super.init()
        
        // TODO: Implement attribute for objectid, updatedat and createdat
        
        type = IntAttribute(propertyName: "type", dao: self)
        status = IntAttribute(propertyName: "status", dao: self)
        nickname = StringAttribute(propertyName: "nickname", dao: self)
        gender = IntAttribute(propertyName: "gender", dao: self)
        birthday = NSDateAttribute(propertyName: "birthday", dao: self)
        ageGroup = IntAttribute(propertyName: "ageGroup", dao: self)
        horoscope = IntAttribute(propertyName: "horoscope", dao: self)
        coverPhoto = OptionalAVFileAttribute(propertyName: "coverPhoto", dao: self)
        whatsUp = OptionalStringAttribute(propertyName: "whatsUp", dao: self)
        latestLocation = OptionalAVGeoPointAttribute(propertyName: "latestLocation", dao: self)
        aaCount = IntAttribute(propertyName: "aaCount", dao: self)
        treatCount = IntAttribute(propertyName: "treatCount", dao: self)
        toGoCount = IntAttribute(propertyName: "toGoCount", dao: self)
        address = OptionalAddressDAOAttribute(propertyName: "address", dao: self)
    }
    
    let type: IntAttribute
    let status: IntAttribute
    let nickname: StringAttribute
    let gender: IntAttribute
    let birthday: NSDateAttribute
    let ageGroup: IntAttribute
    let horoscope: IntAttribute
    let coverPhoto: OptionalAVFileAttribute
    let whatsUp: OptionalStringAttribute
    let latestLocation: OptionalAVGeoPointAttribute
    let aaCount: IntAttribute
    let treatCount: IntAttribute
    let toGoCount: IntAttribute
    let address: OptionalAddressDAOAttribute
}

extension UserDAO {
    static var typedQuery: TypedAVQuery<UserDAO> {
        return UserDAO.query() as! TypedAVQuery<UserDAO>
    }
}

extension UserDAO {
    
    func rac_updatePassword(oldPassword: String, newPassword: String) -> SignalProducer<UserDAO, NetworkError> {
        return super.rac_updatePassword(oldPassword, newPassword: newPassword)
            .mapToDAO(UserDAO)
    }
    
    class func rac_logInWithUsername(username: String, password: String) -> SignalProducer<UserDAO, NetworkError> {
        return super.rac_logInWithUsername(username, password: password)
            .mapToDAO(UserDAO)
    }
    
    class func rac_logInWithPhoneNumber(phoneNumber: String, password: String) -> SignalProducer<UserDAO, NetworkError> {
        return super.rac_logInWithPhoneNumber(phoneNumber, password: password)
            .mapToDAO(UserDAO)
    }
    
    class func rac_logInWithPhoneNumber(phoneNumber: String, smsCode: String) -> SignalProducer<UserDAO, NetworkError> {
        return super.rac_logInWithPhoneNumber(phoneNumber, smsCode: smsCode)
            .mapToDAO(UserDAO)
    }
}

// TODO: Use Reflection to implement a generic conversion to String representation. Implement as protocol extension.

//extension UserDAO : CustomDebugStringConvertible {
//    var debugDescription: String {
//        var s = ""
//        s += "NickName: \(self[Property.nickName])"
//        s += "Gender: \(self[Property.gender])"
//        s += "AgeGroup: \(self[Property.ageGroup])"
//        s += "Horoscope: \(self[Property.horoscope])"
//        
//        return s
//    }
//}