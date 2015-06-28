//
//  FeaturedBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public final class FeaturedBusinessViewModel : ReactiveTableCellViewModel {
    public let businessName: ConstantProperty<String>
    public let city: ConstantProperty<String>
    public let eta: MutableProperty<String> = MutableProperty("")
    public let district: ConstantProperty<String>
    public let coverImageNSURL: ConstantProperty<NSURL?>
    public let participation: MutableProperty<String> = MutableProperty("")
    
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
        
        if let geopoint = geopoint {
            setupEta(CLLocation(latitude: geopoint.latitude, longitude: geopoint.longitude))
        }
        
        // TODO: implement participation
        participation.put("150+ 人想去")
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    
    // MARK: Setup
    
    private func setupEta(destination: CLLocation) {
        self.geoLocationService.calculateETA(destination)
            |> start(next: { interval in
                let minute = Int(ceil(interval / 60))
                self.eta.put(" \(CITY_DISTANCE_SEPARATOR) 开车\(minute)分钟")
            }, error: { error in
                FeaturedLogError(error.description)
            })
    }
}