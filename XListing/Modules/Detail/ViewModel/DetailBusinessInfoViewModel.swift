//
//  DetailBusinessInfoViewModel.swift
//  XListing
//
//  Created by Lance on 2015-05-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit
import SwiftTask
import MapKit

private let 公里 = "公里"
private let 米 = "米"
private let CityDistanceSeparator = " • "

public class DetailBusinessInfoViewModel : NSObject {
    public let navigationTitle: String
    public let businessName: String
    public let websiteURL: NSURL?
    public let phone: String?
    public let coverImageNSURL: NSURL?
    public let cityAndDistance: String
    public var distance: String?
    public let cllocation: CLLocation
    public let fullAddress: String
    public let mapAnnotation: MKPointAnnotation
//    public let objectId: String
//    public let phone: String?
//    public let url: String?
//    
//    public let unit: String?
//    public let address: String?
//    public let district: String?
//    public let city: String?
//    public let state: String?
//    public let country: String?
//    public let postalCode: String?

    
    public init(business: Business, currentLocation: CLLocation? = nil) {
        navigationTitle = business.nameSChinese!
        
        businessName = business.nameSChinese!
        
        if let url = business.url {
            websiteURL = NSURL(string: url)
        }
        else {
            websiteURL = nil
        }
        
        phone = business.phone
        
        if let url = business.cover?.url {
            coverImageNSURL = NSURL(string: url)
        }
        else {
            coverImageNSURL = nil
        }
        
        if let currentLocation = currentLocation {
            
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
        else {
            distance = nil
        }
        
        let distanceText = distance == nil ? "" : "\(CityDistanceSeparator) \(distance)"
        cityAndDistance = "\(business.city!) \(distanceText)"
        
        cllocation = CLLocation(latitude: (business.geopoint?.latitude)!, longitude: (business.geopoint?.longitude)!)
        
        fullAddress = "   \u{f124}   \(business.address!), \(business.city!), \(business.state!)"
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cllocation.coordinate
        annotation.title = businessName
        annotation.subtitle = distance
        mapAnnotation = annotation
    }
}