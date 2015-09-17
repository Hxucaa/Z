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
    public var coverImage: PropertyOf<UIImage?> {
        return PropertyOf(_coverImage)
    }
    public var businessName: PropertyOf<String> {
        return PropertyOf(_businessName)
    }
    public var location: PropertyOf<String> {
        return PropertyOf(_city)
    }
    public var eta: PropertyOf<String> {
        return PropertyOf(_eta)
    }
    
    // MARK: - Properties
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    private let _coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    private let _businessName: MutableProperty<String>
    private let _city: MutableProperty<String>
    private let _eta: MutableProperty<String> = MutableProperty("")
    
    // MARK: - Initializers
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, imageURL: NSURL?, businessName: String?, city: String?, geopoint: AVGeoPoint?) {
        
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
        
        if let url = imageURL {
            self.imageService.getImage(url)
                |> start(next: {
                    self._coverImage.put($0)
                })
        }
        
        if let geopoint = geopoint {
            setupEta(CLLocation(latitude: geopoint.latitude, longitude: geopoint.longitude))
                |> start()
        }
        
    }
    
    
    // MARK: - Setups
    
    private func setupEta(destination: CLLocation) -> SignalProducer<NSTimeInterval, NSError> {
        return geoLocationService.calculateETA(destination)
            |> on(
                next: { interval in
                    let minute = Int(ceil(interval / 60))
                    self._eta.put("\(minute)分钟")
                },
                error: { error in
                    FeaturedLogError(error.description)
                }
        )
    }
}