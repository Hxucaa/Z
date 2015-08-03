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
        if let horoscopeString = horoscope {
            self.horoscope = ConstantProperty(horoscopeString)
        }
        else{
            self.horoscope = ConstantProperty("")
        }
        if let ageGroup = ageGroup {
            var temp = ageGroup + "后"
            self.ageGroup = ConstantProperty(temp)
        } else {
            self.ageGroup = ConstantProperty("")
        }
        
        if let geopoint = geopoint {
            setupEta(CLLocation(latitude: geopoint.latitude, longitude: geopoint.longitude))
        }

        cover?.getDataInBackgroundWithBlock{(data, error) -> Void in
            var image = UIImage(data: data)
            self.coverImage.put(image)
        }
        
//        imageService.getImage(NSURL(string: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSJWn5_oTBOFhan3WPCmtXWMeMbQa_ZFbITTBJStGQvgZGt6l9lOqRLwiy9")!)
//            |> start(next: {
//                self.coverImage.put($0)
//            })
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
    
 
    
    
}