//
//  Business.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class Business : PFObject, PFSubclassing {

    
    // Whether business has been claimed by a business owner
    var isClaimed: Bool {
        get {
            return objectForKey("is_claimed") as Bool
        }
        set {
            setObject(newValue, forKey: "is_claimed")
        }
    }
    
    // Whether business has been (permanently) closed
    var isClosed: Bool {
        get {
            return objectForKey("is_closed") as Bool
        }
        set {
            setObject(newValue, forKey: "is_closed")
        }
    }
    
    // Name of this business
    var name: String {
        get {
            return objectForKey("name") as String
        }
        set {
            setObject(newValue, forKey: "name")
        }
    }
    
    // URL of photo for this business
    var imageUrl: String {
        get {
            return objectForKey("image_url") as String
        }
        set {
            setObject(newValue, forKey: "image_url")
        }
    }
    
    // URL for business page
    var url: String {
        get {
            return objectForKey("url") as String
        }
        set {
            setObject(newValue, forKey: "url")
        }
    }
    
    // URL for mobile business page
    var mobileUrl: String {
        get {
            return objectForKey("mobile_url") as String
        }
        set {
            setObject(newValue, forKey: "mobile_url")
        }
    }
    
    // Phone number for this business with international dialing code (e.g. +442079460000)
    var phone: String {
        get {
            return objectForKey("phone") as String
        }
        set {
            setObject(newValue, forKey: "phone")
        }
    }
    
    // Phone number for this business formatted for display
    var displayPhone: String {
        get {
            return objectForKey("display_phone") as String
        }
    }
    
    // Number of reviews for this business
    var reviewCount: Int {
        get {
            return objectForKey("review_count") as Int
        }
    }
    
    // Distance that business is from search location in meters, if a latitude/longitude is specified.
    var distance: Double {
        get {
            return objectForKey("distance") as Double
        }
    }
    
    // Rating for this business (value ranges from 1, 1.5, ... 4.5, 5)
    var rating: Double {
        get {
            return objectForKey("rating") as Double
        }
    }
    
    // Location
    var location: Location {
        get {
            return objectForKey("location").fetchIfNeeded() as Location
        }
        set {
            setObject(newValue, forKey: "location")
        }
    }
    
    /*!
    Provides a list of category name, alias pairs that this business is associated with. For example,
    [["Local Flavor", "localflavor"], ["Active Life", "active"], ["Mass Media", "massmedia"]]
    The alias is provided so you can search with the category_filter.
    */
    @NSManaged var categories: [String]
    
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