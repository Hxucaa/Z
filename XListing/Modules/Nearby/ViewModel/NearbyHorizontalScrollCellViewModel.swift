//
//  NearbyHorizontalScrollCellViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import MapKit

/**
*  Constants
*/
private let 公里 = "公里"
private let 米 = "米"

public final class NearbyHorizontalScrollCellViewModel {
    private let className: String
    private let objectId: String
    public let businessName: String
    public let wantToGoText: String
    public let coverImageNSURL: NSURL?
    public private(set) var distance: String?
    public let cllocation: CLLocation
    
    public init(business: Business) {
        className = business.className
        
        objectId = business.objectId!
        
        businessName = business.nameSChinese!
        
        let wantToGoCounter = business.wantToGoCounter
        if (wantToGoCounter > 0) {
            wantToGoText = String(format: "%d+ 人想去", wantToGoCounter)
        }
        else {
            wantToGoText = ""
        }
        
        
        if let url = (business.cover?.url) {
            coverImageNSURL = NSURL(string: url)
        }
        else {
            coverImageNSURL = nil
        }
        
        cllocation = CLLocation(latitude: (business.geopoint?.latitude)!, longitude: (business.geopoint?.longitude)!)
    }
    
    public convenience init(business: Business, currentLocation: CLLocation) {
        self.init(business: business)
        
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