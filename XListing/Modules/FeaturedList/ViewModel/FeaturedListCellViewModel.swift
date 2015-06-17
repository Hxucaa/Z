//
//  FeaturedListCellViewModel.swift
//  XListing
//
//  Created by Lance on 2015-05-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import MapKit
import ReactiveCocoa

/**
*  Constants
*/
private let 公里 = "公里"
private let 米 = "米"
private let CityDistanceSeparator = "•"

public final class FeaturedListCellViewModel : NSObject {
    private let className: String
    private let objectId: String
    public let businessName: String
    public let wantToGoText: String
    public let city: String
    public let openingText: String
    public let coverImageNSURL: NSURL?
    public private(set) var distance: String?
    public let etaText: MutableProperty<String> = MutableProperty("")
    private let geoLocationService: IGeoLocationService
    
    public init(business: Business, geoService: IGeoLocationService) {
        geoLocationService = geoService
        
        className = business.className
        
        objectId = business.objectId!
        
        businessName = business.nameSChinese!
        
        let wantToGoCounter = business.wantToGoCounter
        if (wantToGoCounter > 0) {
            wantToGoText = String(format: "附近有%d人想去", wantToGoCounter)
        }
        else {
            wantToGoText = ""
        }
        
        city = business.city!
        
        openingText = "营业中"
        
        if let url = (business.cover?.url) {
            coverImageNSURL = NSURL(string: url)
        }
        else {
            // TODO: fix temp image
            coverImageNSURL = NSURL(string: "http://www.phoenixpalace.co.uk/images/background/aboutus.jpg")
//            coverImageNSURL = nil
        }
    }
    
    /**
    Setup ETA text.
    
    :param: business The business
    */
    private func setupETAText(business: Business) {
        /**
        *  Calculate ETA to the business.
        */
        self.geoLocationService.calculateETA(business.cllocation)
            |> start(next: { interval in
                let minute = Int(ceil(interval / 60))
                self.etaText.put("\(CityDistanceSeparator) 开车\(minute)分钟")
            })
    }
    
    public convenience init(business: Business, currentLocation: CLLocation, geoService: IGeoLocationService) {
        self.init(business: business, geoService: geoService)
        
        self.setupETAText(business)
        
        let busCLLocation = CLLocation(latitude: (business.geopoint?.latitude)!, longitude: (business.geopoint?.longitude)!)
        let distanceInMeter = currentLocation.distanceFromLocation(busCLLocation)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if(distanceInMeter >= 1000) {
            formatter.maximumFractionDigits = 1
            distance = formatter.stringFromNumber(distanceInMeter / 1000)! + 公里
        }
        else {
            formatter.maximumFractionDigits = 0
            distance = formatter.stringFromNumber(distanceInMeter)! + 米
        }
    }
}