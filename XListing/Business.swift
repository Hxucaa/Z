//
//  Business.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class Business : PFObject, PFSubclassing {

//    // Properties
//    var displayName: String {
//        get {
//            return objectForKey("displayName") as String
//        }
//        set {
//            setObject(newValue, forKey: "displayName")
//        }
//    }
    
    // Whether business has been claimed by a business owner
    @NSManaged var is_claimed: Bool
    
    // Whether business has been (permanently) closed
    @NSManaged var is_closed: Bool
    
    // Name of this business
    @NSManaged var name: String
    
    // URL of photo for this business
    @NSManaged var image_url: String
    
    // URL for business page on Yelp
    @NSManaged var url: String
    
    // URL for mobile business page on Yelp
    @NSManaged var mobile_url: String
    
    // Phone number for this business with international dialing code (e.g. +442079460000)
    @NSManaged var phone: String
    
    // Phone number for this business formatted for display
    @NSManaged var display_phone: String
    
    // Number of reviews for this business
    @NSManaged var review_count: String
    
    // Distance that business is from search location in meters, if a latitude/longitude is specified.
    @NSManaged var distance: Double
    
    // Rating for this business (value ranges from 1, 1.5, ... 4.5, 5)
    @NSManaged var rating: Double
    
    // Location
    @NSManaged var location: Location
    
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