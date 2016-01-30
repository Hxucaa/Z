//
//  SocialBusinessHeaderViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveArray
import Dollar
import AVOSCloud

public final class SocialBusinessHeaderViewModel : ISocialBusinessHeaderViewModel {
    
    // MARK: - Outputs
    private let _coverImage: MutableProperty<UIImage?> = MutableProperty(ImageAsset.placeholder)
    public var coverImage: AnyProperty<UIImage?> {
        return AnyProperty(_coverImage)
    }
    
    private let _eta: MutableProperty<String?> = MutableProperty(nil)
    public var eta: AnyProperty<String?> {
        return AnyProperty(_eta)
    }
    
    public let name: ConstantProperty<String>
    public let location: ConstantProperty<String>
    
    // MARK: - Properties
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    
    // MARK: - Initializers
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, coverImage: ImageFile, name: String, city: City, geolocation: Geolocation) {
        
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
        self.name = ConstantProperty(name)
        
        location = ConstantProperty(city.regionNameC)
        
        if let nsurl = NSURL(string: coverImage.url) {
            self.imageService.getImage(nsurl)
                .start { event in
                    switch event {
                    case .Next(let value):
                        self._coverImage.value = value
                    default: break
                    }
                }
        }
        
        setupEta(CLLocation(latitude: geolocation.latitude, longitude: geolocation.longitude))
            .start()
        
    }
    
    
    // MARK: - Setups
    
    private func setupEta(destination: CLLocation) -> SignalProducer<NSTimeInterval, NSError> {
        return geoLocationService.calculateETA(destination)
            .on(
                next: { interval in
                    let minute = Int(ceil(Double(interval) / 60.0))
                    self._eta.value = "\(minute)分钟"
                },
                failed: { error in
                    FeaturedLogError(error.description)
                }
        )
    }
}