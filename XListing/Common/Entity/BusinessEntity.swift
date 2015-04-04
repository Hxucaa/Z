//
//  Business.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class BusinessEntity: PFObject, PFSubclassing {
    
    // Simplified Chinese name of this business
    public var nameSChinese: String? {
        get {
            return self["name_schinese"] as? String
        }
        set {
            self["name_schinese"] = newValue
        }
    }
    
    // Traditional Chinese name of this business
    public var nameTChinese: String? {
        get {
            return self["name_tchinese"] as? String
        }
        set {
            self["name_tchinese"] = newValue
        }
    }
    
    // English name of this business
    public var nameEnglish: String? {
        get {
            return self["name_english"] as? String
        }
        set {
            self["name_english"] = newValue
        }
    }
    
    // Whether business has been claimed by a business owner
    public var isClaimed: Bool? {
        get {
            return self["is_claimed"] as? Bool
        }
        set {
            self["is_claimed"] = newValue
        }
    }
    
    // Whether business has been (permanently) closed
    public var isClosed: Bool? {
        get {
            return self["is_closed"] as? Bool
        }
        set {
            self["is_closed"] = newValue
        }
    }
    
    // Phone number for this business with international dialing code (e.g. +442079460000)
    public var phone: String? {
        get {
            return self["phone"] as? String
        }
        set {
            self["phone"] = newValue
        }
    }
    
    // URL for business page
    public var url: String? {
        get {
            return self["url"] as? String
        }
        set {
            self["url"] = newValue
        }
    }
    
    // URL for mobile business page
    public var mobileUrl: String? {
        get {
            return self["mobile_url"] as? String
        }
        set {
            self["mobile_url"] = newValue
        }
    }
    
    public var uid: String? {
        get {
            return self["uid"] as? String
        }
        set {
            self["uid"] = newValue
        }
    }
    
    // URL of photo for this business
    public var imageUrl: String? {
        get {
            return self["image_url"] as? String
        }
        set {
            self["image_url"] = newValue
        }
    }
    
    // Number of reviews for this business
    public var reviewCount: Int? {
        get {
            return self["review_count"] as? Int
        }
        set {
            self["review_count"] = newValue
        }
    }
    
    // Rating for this business (value ranges from 1, 1.5, ... 4.5, 5)
    public var rating: Double? {
        get {
            return self["rating"] as? Double
        }
        set {
            self["rating"] = newValue
        }
    }
    
    /*!
    Provides a list of category name, alias pairs that this business is associated with. For example,
    [["Local Flavor", "localflavor"], ["Active Life", "active"], ["Mass Media", "massmedia"]]
    The alias is provided so you can search with the category_filter.
    */
    public var categories: [String]? {
        get {
            return self["categories"] as? [String]
        }
        set {
            self["categories"] = newValue
        }
    }
    
}

// PFObject + PFSubclassing required methods
extension BusinessEntity {
    // Class Name
    public class func parseClassName() -> String! {
        return "Business"
    }
    
    // MARK: Constrcutros
    public override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}

// Featured
extension BusinessEntity {
    
    public var featured: Bool? {
        get {
            return objectForKey("featured") as? Bool
        }
        set {
            setObject(newValue, forKey: "featured")
        }
    }
    
    // Starting time of featured business
    public var timeStart: NSDate? {
        get {
            return objectForKey("time_start") as? NSDate
        }
        set {
            setObject(newValue, forKey: "time_start")
        }
    }
    
    // Ending time of featured business
    public var timeEnd: NSDate? {
        get {
            return objectForKey("time_end") as? NSDate
        }
        set {
            setObject(newValue, forKey: "time_end")
        }
    }
}

// location
extension BusinessEntity {
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
    
    public var unit: String? {
        get {
            return self["unit"] as? String
        }
        set {
            self["unit"] = newValue
        }
    }
    
    // Address for this business. Only includes address fields.
    public var address: String? {
        get {
            return self["address"] as? String
        }
        set {
            self["address"] = newValue
        }
    }
    
    public var district: String? {
        get {
            return self["district"] as? String
        }
        set {
            self["distrcit"] = newValue
        }
    }
    
    // City for this business
    public var city: String? {
        get {
            return self["city"] as? String
        }
        set {
            self["city"] = newValue
        }
    }
    
    public var state: String? {
        get {
            return self["state"] as? String
        }
        set {
            self["state"] = newValue
        }
    }
    
    public var country: String? {
        get {
            return self["country"] as? String
        }
        set {
            self["country"] = newValue
        }
    }
    
    // Postal code for this business
    public var postalCode: String? {
        get {
            return self["postal_code"] as? String
        }
        set {
            self["postal_code"] = newValue
        }
    }
    
    // Cross streets for this business
    public var crossStreets: String? {
        get {
            return self["cross_streets"] as? String
        }
        set {
            self["cross_streets"] = newValue
        }
    }
    
    // List that provides neighborhood(s) information for business
    public var neighborhoods: [String]? {
        get {
            return self["neighborhoods"] as? [String]
        }
        set {
            self["neighborhoods"] = newValue
        }
    }
    
    public var geopoint: GeoPointEntity? {
        get {
            if let gp = self["geopoint"] as? PFGeoPoint {
                return GeoPointEntity(gp)
            }
            else {
                return nil
            }
        }
        set {
            self["geopoint"] = newValue?.pfGeoPoint
        }
    }

}