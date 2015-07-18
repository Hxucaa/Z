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
    
    // MARK: Properties
    public let businessName: ConstantProperty<String>
    public let city: ConstantProperty<String>
    public let eta: MutableProperty<String> = MutableProperty("")
    public let district: ConstantProperty<String>
    public let coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    public let participation: MutableProperty<String> = MutableProperty("")
    public let businessHours: ConstantProperty<String> = ConstantProperty("今天 10:00AM - 10:00PM")
    public let annotation: ConstantProperty<MKPointAnnotation>
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    // MARK: Setup
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, businessName: String?, city: String?, district: String?, cover: AVFile?, geopoint: AVGeoPoint?) {
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
        if let businessName = businessName {
            self.businessName = ConstantProperty(businessName)
        } else {
            self.businessName = ConstantProperty("")
        }
        if let city = city {
            self.city = ConstantProperty(city)
        } else {
            self.city = ConstantProperty("")
        }
        if let district = district {
            self.district = ConstantProperty(district)
        } else {
            self.district = ConstantProperty("")
        }

        let businessLocation = CLLocation(latitude: geopoint!.latitude, longitude: geopoint!.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = businessLocation.coordinate
        annotation.title = businessName
        self.annotation = ConstantProperty(annotation)
        
        if let stringURL = cover?.url {
            if let url = NSURL(string: stringURL) {
                imageService.getImage(url)
                    |> start(next: {
                        self.coverImage.put($0)
                    })
            }
        }
        
        // TODO: implement participation
        participation.put("\(arc4random_uniform(100))+ 人想去")
        
        setupEta(businessLocation)
    }
    
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