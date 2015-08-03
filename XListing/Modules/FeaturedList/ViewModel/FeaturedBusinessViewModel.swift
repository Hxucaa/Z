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

public final class FeaturedBusinessViewModel {
    
    public let businessName: ConstantProperty<String>
    public let city: ConstantProperty<String>
    public let eta: MutableProperty<String> = MutableProperty("")
    public let district: ConstantProperty<String>
    public let coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    public let isCoverImageConsumed = MutableProperty<Bool>(false)
    public let participation: MutableProperty<String> = MutableProperty("")
    
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, businessName: String?, city: String?, district: String?, cover: AVFile?, geopoint: AVGeoPoint?, participationCount: Int) {
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
        if let geopoint = geopoint {
            setupEta(CLLocation(latitude: geopoint.latitude, longitude: geopoint.longitude))
        }
        
        participation.put("\(participationCount)+ 人想去")
        
        if let url = cover?.url, nsurl = NSURL(string: url) {
            self.imageService.getImage(nsurl)
                |> start(next: {
                    self.coverImage.put($0)
                })
        }
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
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