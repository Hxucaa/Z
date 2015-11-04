//
//  SocialBusinessHeaderViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray
import Dollar
import AVOSCloud

public final class SocialBusinessHeaderViewModel : ISocialBusinessHeaderViewModel {
    // MARK: - Outputs
    public var coverImage: AnyProperty<UIImage?> {
        return AnyProperty(_coverImage)
    }
    public var businessName: AnyProperty<String> {
        return AnyProperty(_businessName)
    }
    public var location: AnyProperty<String> {
        return AnyProperty(_city)
    }
    public var eta: AnyProperty<String?> {
        return AnyProperty(_eta)
    }
    
    // MARK: - Properties
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    private let _coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    private let _businessName: MutableProperty<String>
    private let _city: MutableProperty<String>
    private let _eta: MutableProperty<String?> = MutableProperty(nil)
    
    // MARK: - Initializers
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, cover: ImageFile?, businessName: String?, city: String?, geolocation: Geolocation?) {
        
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
        if let businessName = businessName {
            _businessName = MutableProperty(businessName)
        } else {
            _businessName = MutableProperty("")
        }
        
        if let city = city {
            _city = MutableProperty(city)
        } else {
            _city = MutableProperty("")
        }
        
        if let url = cover?.url, nsurl = NSURL(string: url) {
            self.imageService.getImage(nsurl)
                .start { event in
                    switch event {
                    case .Next(let value):
                        self._coverImage.value = value
                    default: break
                    }
                }
        }
        
        if let geolocation = geolocation {
            setupEta(CLLocation(latitude: geolocation.latitude, longitude: geolocation.longitude))
                .start()
        }
        
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