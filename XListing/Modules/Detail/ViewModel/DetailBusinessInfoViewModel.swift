//
//  DetailBusinessInfoViewModel.swift
//  XListing
//
//  Created by Lance on 2015-05-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit

private let 公里 = "公里"
private let 米 = "米"
private let CityDistanceSeparator = " • "

public struct DetailBusinessInfoViewModel {
    public let navigationTitle: ConstantProperty<String>
    public let businessName: ConstantProperty<String>
    public let websiteURL: ConstantProperty<NSURL?>
    public let phone: ConstantProperty<String?>
    public let phoneURL: ConstantProperty<NSURL?>
    public let cityAndDistance: ConstantProperty<String>
    public let distance: ConstantProperty<String?>
    public let cllocation: ConstantProperty<CLLocation>
    
    public init(business: Business, currentLocation: CLLocation? = nil) {
        navigationTitle = ConstantProperty<String>(business.nameSChinese!)
        
        businessName = ConstantProperty<String>(business.nameSChinese!)
        
        if let url = business.url {
            websiteURL = ConstantProperty<NSURL?>(NSURL(string: url))
        }
        else {
            websiteURL = ConstantProperty<NSURL?>(nil)
        }
        
        phone = ConstantProperty<String?>(business.phone!)
        
        phoneURL = ConstantProperty<NSURL?>(NSURL(string: "tel:\(business.phone!)"))
        
        if let currentLocation = currentLocation {
            
            let busCLLocation = CLLocation(latitude: (business.geopoint?.latitude)!, longitude: (business.geopoint?.longitude)!)
            let distanceInMeter = currentLocation.distanceFromLocation(busCLLocation)
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            if(distanceInMeter >= 1000) {
                formatter.maximumFractionDigits = 1
                let d = formatter.stringFromNumber(distanceInMeter / 1000)! + 公里
                distance = ConstantProperty<String?>(d)
            }
            else {
                formatter.maximumFractionDigits = 0
                let d = formatter.stringFromNumber(distanceInMeter)! + 米
                distance = ConstantProperty<String?>(d)
            }
            
        }
        else {
            distance = ConstantProperty<String?>(nil)
        }
        
        let distanceText = distance.value == nil ? "" : "\(CityDistanceSeparator) \(distance.value)"
        cityAndDistance = ConstantProperty<String>("\(business.city!) \(distanceText)")
        
        cllocation = ConstantProperty<CLLocation>(CLLocation(latitude: (business.geopoint?.latitude)!, longitude: (business.geopoint?.longitude)!))
    }
}