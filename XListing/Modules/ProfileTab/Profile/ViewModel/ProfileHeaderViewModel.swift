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

public final class ProfileHeaderViewModel {
    
    // MARK: - Input
    
    // MARK: - Output
    public let name: ConstantProperty<String>
    public let horoscope: ConstantProperty<String>
    public let city: ConstantProperty<String>
    public let district: ConstantProperty<String>
    public let ageGroup: ConstantProperty<String>
    public let eta: MutableProperty<String> = MutableProperty("")
    public let coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.profilepicture))
    
    // MARK: - Services
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, name: String?, city: String?, district: String?, horoscope: Horoscope?, ageGroup: AgeGroup?, cover: ImageFile?, geolocation: Geolocation?) {
        
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
        
        self.horoscope = ConstantProperty(convertHoroscope(horoscope))
        
        self.ageGroup = ConstantProperty(convertAgeGroup(ageGroup))
        
        if let geolocation = geolocation {
            setupEta(geolocation.cllocation)
        }

        if let url = cover?.url, nsurl = NSURL(string: url) {
            imageService.getImage(nsurl)
                |> start(next: { [weak self] image in
                    self?.coverImage.put(image)
                })
        }
        
    }
    
    // MARK: Setup
    
    private func setupEta(destination: CLLocation) {
        self.geoLocationService.calculateETA(destination)
            |> start(
                next: { interval in
                    let minute = Int(ceil(interval / 60))
                    self.eta.put(" \(CITY_DISTANCE_SEPARATOR) 开车\(minute)分钟")
                },
                error: { error in
                    FeaturedLogError(error.description)
                }
            )
    }
}