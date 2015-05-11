//
//  BusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

/**
*  Constants
*/
private let 公里 = "公里"
private let 米 = "米"
private let CityDistanceSeparator = " • "

public class BusinessViewModel : NSObject {
    
    public private(set) var objectId: String?
    public private(set) var createdAt: NSDate?
    public private(set) var updatedAt: NSDate?
    
    /**
    *  Business info
    */
    public private(set) var nameSChinese: String?
    public private(set) var nameTChinese: String?
    public private(set) var nameEnglish: String?
    public private(set) var isClaimed: Bool = false
    public private(set) var isClosed: Bool = false
    public private(set) var phone: String?
    public private(set) var url: String?
    public private(set) var mobileUrl: String?
    public private(set) var uid: String?
    public private(set) var imageUrl: String?
    public private(set) var reviewCount: Int = 0
    public private(set) var rating: Double = -1
    public private(set) var coverImageUrl: String?
    
    /**
    *  Featured
    */
    public private(set) var featured: Bool = false
    public private(set) var timeStart: NSDate?
    public private(set) var timeEnd: NSDate?
    
    /**
    *  Location
    */
    public private(set) var unit: String?
    public private(set) var address: String?
    public private(set) var district: String?
    public private(set) var city: String?
    public private(set) var state: String?
    public private(set) var country: String?
    public private(set) var postalCode: String?
    public private(set) var crossStreets: String?
    public private(set) var latitude: Double?
    public private(set) var longitude: Double?
    
    public private(set) var distance: String?
    
    /**
    *  Statistics
    */
    public private(set) var wantToGoCounter: Int = 0
    
    public var businessName: String {
        get {
            return nameSChinese!
        }
    }
    
    public var cityAndDistance: String {
        get {
            let distanceText = distance == nil ? "" : "\(CityDistanceSeparator) \(distance!)"
            return "\(city!) \(distanceText)"
        }
    }
    
    public var coverImageNSURL: NSURL? {
        get {
            return NSURL(string: coverImageUrl!)
        }
    }
    
    public init(business: BusinessDAO) {
        objectId = business.objectId
        createdAt = business.createdAt
        updatedAt = business.updatedAt
        
        nameSChinese = business.nameSChinese
        nameTChinese = business.nameTChinese
        nameEnglish = business.nameEnglish
        isClaimed = business.isClaimed!
        isClosed = business.isClosed!
        phone = business.phone
        url = business.url
        mobileUrl = business.mobileUrl
        uid = business.uid
        imageUrl = business.imageUrl
        reviewCount = business.reviewCount!
        rating = business.rating!
        coverImageUrl = business.cover?.url
        
        featured = business.featured!
        timeStart = business.timeStart
        timeEnd = business.timeEnd
        
        unit = business.unit
        address = business.address
        district = business.district
        city = business.city
        state = business.state
        country = business.country
        postalCode = business.postalCode
        crossStreets = business.crossStreets
        latitude = business.geopoint?.latitude
        longitude = business.geopoint?.longitude
        
        wantToGoCounter = business.wantToGoCounter!
        
        coverImageUrl = "http://www.afroglobe.net/wp-content/uploads/2015/03/Wonderful-Life-With-Fantastic-Chinese-Restaurant-Design-Idea-2.jpg"
        
        super.init()
        
//        cityAndDistanceStream = [
//                KVO.startingStream(self, "city"),
//                KVO.startingStream(self, "distance")
//            ]
//            |> combineLatestAll
//            |> map { [unowned self] values -> NSString? in
//                let distanceText = values[1] == nil ? "" : "\(CityDistanceSeparator) \(values[1]!)"
//                return "\(values[0]!) \(distanceText)"
//            }
    }
    
    deinit {
        println("deinit from businessViewModel")
    }
    
    public convenience init(business: BusinessDAO, currentLocation: CLLocation) {
        self.init(business: business)

        let busCLLocation = CLLocation(latitude: (business.geopoint?.latitude)!, longitude: (business.geopoint?.longitude)!)
        let distanceInMeter = currentLocation.distanceFromLocation(busCLLocation)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if(distanceInMeter >= 1000) {
            formatter.maximumFractionDigits = 1
            self.distance = formatter.stringFromNumber(distanceInMeter / 1000)! + 公里
        }
        else {
            formatter.maximumFractionDigits = 0
            self.distance = formatter.stringFromNumber(distanceInMeter)! + 米
        }
    }
    
    public func getWantToGoText() -> String {
        if (wantToGoCounter > 0) {
            return String(format: "%d+ 人想去", wantToGoCounter)
        }
        else {
            return ""
        }
    }
    
    public func getOpeningText() -> String {
        return "营业中"
    }
    
    public func getCLLocation() -> CLLocation {
        return CLLocation(latitude: latitude!, longitude: longitude!)
    }
    
    public func getNSURL() -> NSURL? {
        if let url = url {
            return NSURL(string: url)
        }
        else {
            return nil
        }
    }
}

extension BusinessViewModel : Printable {
    
    public override var description: String {
        let bdMirror = reflect(self)
        var result = ""
        for var i = 0; i < bdMirror.count; i++ {
            let (propertyName, childMirror) = bdMirror[i]
            
            result += "\(propertyName): \(childMirror.value)\n"
        }
        result += "\n"
        return result
    }
}