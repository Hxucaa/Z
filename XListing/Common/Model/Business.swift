//
//  BusinessDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public final class Business: AVObject, AVSubclassing {
    
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
    public dynamic var nameSChinese: String?
    
    // Traditional Chinese name of this business
    public dynamic var nameTChinese: String?
    
    // English name of this business
    public dynamic var nameEnglish: String?
    
    // Whether business has been claimed by a business owner
    public dynamic var isClaimed: Bool = false
    
    // Whether business has been (permanently) closed
    public dynamic var isClosed: Bool = false
    
    // Phone number for this business with international dialing code (e.g. +442079460000)
    public dynamic var phone: String?
    
    // URL for business page
    public dynamic var url: String?
    
    // URL for mobile business page
    public dynamic var mobileUrl: String?
    
    public dynamic var uid: String?
    
    // URL of photo for this business
    public dynamic var imageUrl: String?
    
    // Number of reviews for this business
    public dynamic var reviewCount: Int = 0
    
    // Rating for this business (value ranges from 1, 1.5, ... 4.5, 5)
    public dynamic var rating: Double = -1
    
    public dynamic var cover: AVFile?
    
    /**
    Featured
    */
    
    public dynamic var featured: Bool = false
    
    // Starting time of featured business
    public dynamic var timeStart: NSDate?
    
    // Ending time of featured business
    public dynamic var timeEnd: NSDate?
    
    /**
    Statistics
    */
    
    
    public dynamic var wantToGoCounter: Int = 0
    
    /*!
    Provides a list of category name, alias pairs that this business is associated with. For example,
    [["Local Flavor", "localflavor"], ["Active Life", "active"], ["Mass Media", "massmedia"]]
    The alias is provided so you can search with the category_filter.
    */
    public dynamic var categories: [String]?
    
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
    
    public dynamic var unit: String?
    
    // Address for this business. Only includes address fields.
    public dynamic var address: String?
    
    public dynamic var district: String?
    
    // City for this business
    public dynamic var city: String?
    
    public dynamic var state: String?
    
    public dynamic var country: String?
    
    // Postal code for this business
    public dynamic var postalCode: String?
    
    // Cross streets for this business
    public dynamic var crossStreets: String?
    
    // List that provides neighborhood(s) information for business
    public dynamic var neighborhoods: [String]?
    
    public dynamic var geopoint: AVGeoPoint?
}