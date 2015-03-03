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
    @NSManaged private(set) var is_claimed: Bool
    
    // Whether business has been (permanently) closed
    @NSManaged private(set) var is_closed: Bool
    
    // Name of this business
    @NSManaged private(set) var name: String
    
    // URL of photo for this business
    @NSManaged private(set) var image_url: String
    
    // URL for business page on Yelp
    @NSManaged private(set) var url_: String
    
    // URL for mobile business page on Yelp
    @NSManaged private(set) var mobile_url: String
    
    // Phone number for this business
    // TODO: implement standard formatting
    @NSManaged private(set) var phone_: String
    
    // Number of reviews for this business
    @NSManaged private(set) var review_count: String
    
    // Distance that business is from search location in meters, if a latitude/longitude is specified.
    @NSManaged private(set) var distance_: Double
    
    // Rating for this business (value ranges from 1, 1.5, ... 4.5, 5)
    @NSManaged private(set) var rating_: Double
    
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