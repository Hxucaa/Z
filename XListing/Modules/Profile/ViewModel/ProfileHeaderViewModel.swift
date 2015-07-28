//
//  ProfileHeaderViewModel.swift
//  XListing
//
//  Created by Anson on 2015-07-26.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import Dollar

public struct ProfileHeaderViewModel {
    public let name: ConstantProperty<String>
    public let horoscope: ConstantProperty<String>
    public let city: ConstantProperty<String>
    public let district: ConstantProperty<String>
    public let ageGroup: ConstantProperty<String>
    public let eta: MutableProperty<String> = MutableProperty("")
    public let coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.profilepicture))
    
    
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, name: String?, city: String?, district: String?, horoscope: String?, ageGroup: String?, cover: AVFile?, geopoint: AVGeoPoint?) {
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
        if let name = name {
            self.name = ConstantProperty(name)
        } else {
            self.name = ConstantProperty("")
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
        if let horoscope = horoscope {
            self.horoscope = ConstantProperty(horoscope)
        } else {
            self.horoscope = ConstantProperty("")
        }
        if let ageGroup = ageGroup {
            self.ageGroup = ConstantProperty(ageGroup)
        } else {
            self.ageGroup = ConstantProperty("")
        }
        
        if let geopoint = geopoint {
            setupEta(CLLocation(latitude: geopoint.latitude, longitude: geopoint.longitude))
        }

        
        imageService.getImage(NSURL(string: "http://www.washingtonpost.com/blogs/the-fix/wp/2014/10/20/obama-giftwraps-another-sound-bite-for-republicans/")!)
            |> start(next: {
                self.coverImage.put($0)
            })
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
    
    
    // MARK: Setup
    
    private func setupHoroscope() {
//        self.geoLocationService.calculateETA(destination)
//            |> start(next: { interval in
//                let minute = Int(ceil(interval / 60))
//                self.eta.put(" \(CITY_DISTANCE_SEPARATOR) 开车\(minute)分钟")
//                }, error: { error in
//                    FeaturedLogError(error.description)
//            })
    }

    
    
}