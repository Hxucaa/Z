//
//  NearbyTableCellViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-22.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import MapKit

public struct NearbyTableCellViewModel {
    public let businessName: ConstantProperty<String>
    public let city: ConstantProperty<String>
    public let eta: MutableProperty<String> = MutableProperty("")
    public let district: ConstantProperty<String>
    public let coverImageNSURL: ConstantProperty<NSURL?>
    public let participation: MutableProperty<String> = MutableProperty("")
    public let businessHours: ConstantProperty<String> = ConstantProperty("今天 10:00AM - 10:00PM")
    public let annotation: ConstantProperty<MKPointAnnotation>
    
    public init(geoLocationService: IGeoLocationService, businessName: String?, city: String?, district: String?, cover: AVFile?, geopoint: AVGeoPoint?) {
        self.geoLocationService = geoLocationService
        
        self.businessName = ConstantProperty(businessName!)
        
        self.city = ConstantProperty(city!)
        
        self.district = ConstantProperty(district!)
        
        if let url = cover?.url {
            coverImageNSURL = ConstantProperty<NSURL?>(NSURL(string: url))
        }
        else {
            // TODO: fix temp image
            coverImageNSURL = ConstantProperty<NSURL?>(NSURL(string: "http://www.phoenixpalace.co.uk/images/background/aboutus.jpg"))
            //            coverImageNSURL = nil
        }
        
        let businessLocation = CLLocation(latitude: geopoint!.latitude, longitude: geopoint!.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = businessLocation.coordinate
        annotation.title = businessName
        //            annotation.subtitle =
        self.annotation = ConstantProperty(annotation)
        
        // TODO: implement participation
        participation.put("\(arc4random_uniform(100))+ 人想去")
        
        
        setupEta(businessLocation)
        
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    
    // MARK: Setup
    
    private func setupEta(destination: CLLocation) {
        geoLocationService.calculateETA(destination)
            |> start(next: { interval in
                let minute = Int(ceil(interval / 60))
                self.eta.put(" \(CITY_DISTANCE_SEPARATOR) 开车\(minute)分钟")
                }, error: { error in
                    FeaturedLogError(error.description)
            })
    }
}