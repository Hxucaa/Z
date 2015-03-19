//
//  Business.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class BusinessEntity: PFObject, PFSubclassing {
    
    
    // Simplified Chinese name of this business
    var nameSChinese: String? {
        get {
            return self["name_schinese"] as? String
        }
        set {
            self["name_schinese"] = newValue
        }
    }
    
    // Traditional Chinese name of this business
    var nameTChinese: String? {
        get {
            return self["name_tchinese"] as? String
        }
        set {
            self["name_tchinese"] = newValue
        }
    }
    
    // English name of this business
    var nameEnglish: String? {
        get {
            return self["name_english"] as? String
        }
        set {
            self["name_english"] = newValue
        }
    }
    
    // Whether business has been claimed by a business owner
    var isClaimed: Bool {
        get {
            return self["is_claimed"] as Bool
        }
        set {
            self["is_claimed"] = newValue
        }
    }
    
    // Whether business has been (permanently) closed
    var isClosed: Bool {
        get {
            return self["is_closed"] as Bool
        }
        set {
            self["is_closed"] = newValue
        }
    }
    
    // Phone number for this business with international dialing code (e.g. +442079460000)
    var phone: String {
        get {
            return self["phone"] as String
        }
        set {
            self["phone"] = newValue
        }
    }
    
    // URL for business page
    var url: String? {
        get {
            return self["url"] as? String
        }
        set {
            self["url"] = newValue
        }
    }
    
    // URL for mobile business page
    var mobileUrl: String? {
        get {
            return self["mobile_url"] as? String
        }
        set {
            self["mobile_url"] = newValue
        }
    }
    
    var uid: String {
        get {
            return self["uid"] as String
        }
        set {
            self["uid"] = newValue
        }
    }
    
    // URL of photo for this business
    var imageUrl: String? {
        get {
            return self["image_url"] as? String
        }
        set {
            self["image_url"] = newValue
        }
    }
    
//    // Phone number for this business formatted for display
//    var displayPhone: String {
//        get {
//            return self["display_phone"] as String
//        }
//        set {
//            self["display_phone"] = newValue
//        }
//    }
    
    // Number of reviews for this business
    var reviewCount: Int {
        get {
            return self["review_count"] as Int
        }
        set {
            self["review_count"] = newValue
        }
    }
    
    // Distance that business is from search location in meters, if a latitude/longitude is specified.
//    var distance: Double {
//        get {
//            return self["distance"] as Double
//        }
//    }
    
    // Rating for this business (value ranges from 1, 1.5, ... 4.5, 5)
    var rating: Double? {
        get {
            return self["rating"] as? Double
        }
        set {
            self["rating"] = newValue
        }
    }
    
    // Location
    var location: LocationEntity {
        get {
            return self["location"] as LocationEntity
        }
        set {
            self["location"] = newValue
        }
    }
    
    /*!
    Provides a list of category name, alias pairs that this business is associated with. For example,
    [["Local Flavor", "localflavor"], ["Active Life", "active"], ["Mass Media", "massmedia"]]
    The alias is provided so you can search with the category_filter.
    */
    var categories: [String] {
        get {
            return self["categories"] as [String]
        }
        set {
            self["categories"] = newValue
        }
    }
    
    // Class Name
    class func parseClassName() -> String! {
        return "Business"
    }

    // MARK: Constrcutros
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
}