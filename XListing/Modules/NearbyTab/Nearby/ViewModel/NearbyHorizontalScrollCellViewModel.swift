//
//  NearbyTableCellViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-22.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit

public final class NearbyTableCellViewModel {
    
    // MARK: Properties
    public let businessName: ConstantProperty<String>
    public let city: ConstantProperty<String>
    public let eta: MutableProperty<String> = MutableProperty("")
    public let district: ConstantProperty<String>
    public let coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    public let participation: MutableProperty<String>
    public let businessHours: ConstantProperty<String> = ConstantProperty("今天 10:00AM - 10:00PM")
    public let annotation: ConstantProperty<MKPointAnnotation>
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let businessLocation: Geolocation
    
    // MARK: Setup
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, businessName: String?, city: String?, district: String?, cover: ImageFile?, geolocation: Geolocation?, aaCount: Int, treatCount: Int, toGoCount: Int) {
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
        
        
        participation = MutableProperty("\(aaCount + treatCount + toGoCount)+ 人想去")
        
        businessLocation = geolocation!
            
        let annotation = MKPointAnnotation()
        annotation.coordinate = businessLocation.cllocation.coordinate
        annotation.title = businessName
        self.annotation = ConstantProperty(annotation)
        
        setupEta(businessLocation.cllocation)
        
        imageService.getImage(NSURL(string: "http://lasttear.com/wp-content/uploads/2015/03/interior-design-ideas-furniture-architecture-mesmerizing-chinese-restaurant-interior-with-red-nuance-inspiring.jpg")!)
            .startWithNext {
                self.coverImage.value = $0
            }
        
    }
    
    private func setupEta(destination: CLLocation) {
        geoLocationService.calculateETA(destination)
            .start { event in
                switch event {
                case .Next(let interval):
                    let minute = Int(ceil(interval / 60))
                    self.eta.value = " \(CITY_DISTANCE_SEPARATOR) 开车\(minute)分钟"
                case .Failed(let error):
                    FeaturedLogError(error.description)
                default: break
                }
            }
    }
}