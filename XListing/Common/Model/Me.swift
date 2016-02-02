//
//  Me.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-18.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public class _BaseObject {
    public let objectId: String
    public let updatedAt: NSDate
    public let createdAt: NSDate
    
    public let isActive: Activation
    
    public init(objectId: String, updatedAt: NSDate, createdAt: NSDate, isActive: Activation) {
        self.objectId = objectId
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.isActive = isActive
    }
}

public class UserObject : _BaseObject {
    
    public let type: UserType
    public let status: UserStatus
    public let nickname: String
    public let gender: Gender
    public let ageGroup: AgeGroup
    public let horoscope: Horoscope
    public let coverPhoto: ImageFile
    public let whatsUp: String?
    public let latestLocation: Geolocation?
    public let aaCount: Int
    public let treatCount: Int
    public let toGoCount: Int
    
    public init(objectId: String, updatedAt: NSDate, createdAt: NSDate, isActive: Activation, type: UserType, status: UserStatus, nickname: String, gender: Gender, ageGroup: AgeGroup, horoscope: Horoscope, coverPhoto: ImageFile, whatsUp: String?, latestLocation: Geolocation?, aaCount: Int, treatCount: Int, toGoCount: Int) {
        
        self.type = type
        self.status = status
        self.nickname = nickname
        self.gender = gender
        self.ageGroup = ageGroup
        self.horoscope = horoscope
        self.coverPhoto = coverPhoto
        self.whatsUp = whatsUp
        self.latestLocation = latestLocation
        self.aaCount = aaCount
        self.treatCount = treatCount
        self.toGoCount = toGoCount
        
        super.init(objectId: objectId, updatedAt: updatedAt, createdAt: createdAt, isActive: isActive)
    }
}

public class MeObject : UserObject {
    
    public let birthday: NSDate
    public let address: AddressObject?
    
    public init(objectId: String, updatedAt: NSDate, createdAt: NSDate, isActive: Activation, type: UserType, status: UserStatus, nickname: String, gender: Gender, birthday: NSDate, ageGroup: AgeGroup, horoscope: Horoscope, address: AddressObject?, coverPhoto: ImageFile, whatsUp: String?, latestLocation: Geolocation?, aaCount: Int, treatCount: Int, toGoCount: Int) {
        
        self.birthday = birthday
        self.address = address
        
        super.init(objectId: objectId, updatedAt: updatedAt, createdAt: createdAt, isActive: isActive, type: type, status: status, nickname: nickname, gender: gender, ageGroup: ageGroup, horoscope: horoscope, coverPhoto: coverPhoto, whatsUp: whatsUp, latestLocation: latestLocation, aaCount: aaCount, treatCount: treatCount, toGoCount: toGoCount)
    }
}

public class AddressObject : _BaseObject {
    
    public let street: String
    public let district: District
    public let city: City
    public let province: Province
    public let postalCode: String
    public let geoLocation: Geolocation
    public let fullAddress: String
    
    public init(objectId: String, updatedAt: NSDate, createdAt: NSDate, isActive: Activation, street: String, district: District, city: City, province: Province, postalCode: String, geoLocation: Geolocation, fullAddress: String) {
        
        self.street = street
        self.district = district
        self.city = city
        self.province = province
        self.postalCode = postalCode
        self.geoLocation = geoLocation
        self.fullAddress = fullAddress
        
        super.init(objectId: objectId, updatedAt: updatedAt, createdAt: createdAt, isActive: isActive)
    }
}

public class _BaseRepository {
    
}

public class UserRepository : _BaseRepository {
    
    private let userService: IUserService
    
    public init(userService: IUserService) {
        self.userService = userService
    }
    
}

public class BusinessRepository : _BaseRepository {
    
    private let businessService: IBusinessService
    
    public init(businessService: IBusinessService) {
        self.businessService = businessService
    }
    
    public func getByPagination() {
        
    }
}

import ReactiveArray

public class _BasePagedList<T> {
    
    public let subset: ReactiveArray<T> = ReactiveArray()

    public var count: Int {
        return subset.count
    }
}

//public class PagedList<T> : _BasePagedList<T> {
//    
//    public init(
//}

public final class Me : User {
    
    public struct Property {
        static let birthday = "birthday"
    }
    
    public override func toString() -> String {
        var s = ""
        s += "birthday: \(self[Property.birthday])"
        s += super.toString()
        return s
    }
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    public override var type: UserType {
        get {
            return UserType(rawValue: self[Property.type] as! Int)!
        }
        set {
            self[Property.type] = newValue.rawValue
        }
    }
    
    public override var gender: Gender {
        get {
            return Gender(rawValue: self[Property.gender] as! Int)!
        }
        set {
            self[Property.gender] = newValue.rawValue
        }
    }
    
    @NSManaged public var birthday: NSDate
//    public var birthday: NSDate {
//        get {
//            return self[Property.birthday] as! NSDate
//        }
//        set {
//            self[Property.birthday] = newValue
//        }
//    }
    
    
    @NSManaged public var address: Address?
    
    public func setCoverPhoto(name: String, data: NSData) {
        self[Property.coverPhoto] = AVFile(name: name, data: data)
    }
    
//    public override var whatsUp: String? {
//        get {
//            guard let whatsUp = self.objectForKey(Property.whatsUp) else {
//                return nil
//            }
//            return whatsUp as? String
//        }
//        set {
//            self[Property.whatsUp] = newValue
//        }
//    }
    
    public override var latestLocation: Geolocation? {
        get {
            guard let geopoint = self[Property.latestLocation] as? AVGeoPoint else {
                return nil
            }
            return Geolocation(latitude: geopoint.latitude, longitude: geopoint.longitude)
        }
        set {
            if let newValue = newValue {
                self[Property.latestLocation] = AVGeoPoint(latitude: newValue.latitude, longitude: newValue.longitude)
            }
        }
    }
}
