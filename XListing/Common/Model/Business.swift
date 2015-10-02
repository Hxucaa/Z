//
//  BusinessDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud
import MapKit

public final class Business: AVObject, AVSubclassing {
    
    public enum Property : String {
        case NameSChinese = "nameSChinese"
        case NameTChinese = "nameTChinese"
        case NameEnglish = "nameEnglish"
        case IsClaimed = "isClaimed"
        case IsClosed = "isClosed"
        case Phone = "phone"
        case Url = "url"
        case MobileUrl = "mobileUrl"
        case Uid = "uid"
        case ImageUrl = "imageUrl"
        case ReviewCount = "reviewCount"
        case Rating = "rating"
        case Cover = "cover"
        case Featured = "featured"
        case TimeStart = "timeStart"
        case TimeEnd = "timeEnd"
        case aaCount = "aaCount"
        case treatCount = "treatCount"
        case toGoCount = "toGoCount"
        case Unit = "unit"
        case Address = "address"
        case District = "district"
        case City = "city"
        case State = "state"
        case Country = "country"
        case PostalCode = "postalCode"
        case Geolocation = "geopoint"
        case Price = "price"
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(withoutDataWithObjectId id: String) {
        self.init()
        self.objectId = id
    }
    
    // Class Name
    public class func parseClassName() -> String {
        return "Business"
    }
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    // Simplified Chinese name of this business
    @NSManaged public var nameSChinese: String?
    
    // Traditional Chinese name of this business
    @NSManaged public var nameTChinese: String?
    
    // English name of this business
    @NSManaged public var nameEnglish: String?
    
    // Whether business has been claimed by a business owner
    @NSManaged public var isClaimed: Bool
    
    // Whether business has been (permanently) closed
    @NSManaged public var isClosed: Bool
    
    // Phone number for this business with international dialing code (e.g. +442079460000)
    @NSManaged public var phone: String?
    
    // URL for business page
    @NSManaged public var url: String?
    
    // URL for mobile business page
    @NSManaged public var mobileUrl: String?
    
    @NSManaged public var uid: String?
    
    // URL of photo for this business
    @NSManaged public var imageUrl: String?
    
    // Number of reviews for this business
    @NSManaged public var reviewCount: Int
    
    // Rating for this business (value ranges from 1, 1.5, ... 4.5, 5)
    @NSManaged public var rating: Double
    
    @NSManaged private var cover: AVFile?
    public var cover_: ImageFile? {
        get {
            if let url = cover?.url {
                return ImageFile(url: url)
            }
            else {
                return nil
            }
        }
        set {
            if let newValue = newValue {
                cover = AVFile(name: newValue.name, data: newValue.data)
            }
        }
    }
    
    @NSManaged public var price: Int
    
    /**
    Featured
    */
    
    @NSManaged public var featured: Bool
    
    // Starting time of featured business
    @NSManaged public var timeStart: NSDate?
    
    // Ending time of featured business
    @NSManaged public var timeEnd: NSDate?
    
    /**
    Statistics
    */
    
    
    @NSManaged public var aaCount: Int
    
    @NSManaged public var treatCount: Int
    
    @NSManaged public var toGoCount: Int
    
    
    /**
    Location
    */
    
    public var completeAddress: String? {
        get {
            var addressString = ""
            if let address = address {
                addressString += "\(address) "
            }
            else {
                return nil
            }
            if let city = city {
                addressString += "\(city) "
            }
            else {
                return nil
            }
            if let state = state {
                addressString += "\(state) "
            }
            else {
                return nil
            }
            if let country = country {
                addressString += "\(country)"
            }
            else {
                return nil
            }
            return addressString
        }
    }
    
    @NSManaged public var unit: String?
    
    // Address for this business. Only includes address fields.
    @NSManaged public var address: String?
    
    @NSManaged public var district: String?
    
    // City for this business
    @NSManaged public var city: String?
    
    @NSManaged public var state: String?
    
    @NSManaged public var country: String?
    
    // Postal code for this business
    @NSManaged public var postalCode: String?
    
    @NSManaged private var geopoint: AVGeoPoint?
    public var geolocation: Geolocation? {
        get {
            if let geopoint = geopoint {
                return Geolocation(latitude: geopoint.latitude, longitude: geopoint.longitude)
            }
            return nil
        }
        set {
            if let newValue = newValue {
                geopoint = AVGeoPoint(latitude: newValue.latitude, longitude: newValue.longitude)
            }
        }
    }
}