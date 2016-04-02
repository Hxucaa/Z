//
//  BasicBusinessInfoViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public class BasicBusinessInfoViewModel : IBasicBusinessInfoViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs

    public let name: ConstantProperty<String>
    public let phone: ConstantProperty<String>
    public let email: ConstantProperty<String?>
    public let websiteUrl: ConstantProperty<NSURL?>
    public let district: ConstantProperty<String?>
    public let city: ConstantProperty<String>
    public let province: ConstantProperty<String>
    public let coverImageUrl: ConstantProperty<NSURL?>
    
    private let _coverImage: MutableProperty<UIImage> = MutableProperty(ImageAsset.placeholder)
    public var coverImage: AnyProperty<UIImage> {
        return AnyProperty(_coverImage)
    }
    
    public let description: ConstantProperty<String?>
    public let averagePrice: ConstantProperty<String>
    public let aaCount: ConstantProperty<Int>
    public let treatCount: ConstantProperty<Int>
    public let toGoCount: ConstantProperty<Int>
    
    private let _eta: MutableProperty<String?> = MutableProperty(nil)
    public var eta: AnyProperty<String?> {
        return AnyProperty(_eta)
    }

    // MARK: - Properties
    private let business: Business

    // MARK: Services
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService

    // MARK: - Initializers

    public init(geoLocationService: IGeoLocationService, imageService: IImageService, business: Business) {
        
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
        name = ConstantProperty(business.name)
        phone = ConstantProperty(business.phone)
        email = ConstantProperty(business.email)
        websiteUrl = ConstantProperty(business.websiteUrl)
        district = ConstantProperty(business.address.district.regionNameC)
        city = ConstantProperty(business.address.city.regionNameC)
        province = ConstantProperty(business.address.province.regionNameC)
        coverImageUrl = ConstantProperty(business.coverImage.url)
        description = ConstantProperty(business.descriptor)
        averagePrice = ConstantProperty("")
        aaCount = ConstantProperty(business.aaCount)
        treatCount = ConstantProperty(business.treatCount)
        toGoCount = ConstantProperty(business.toGoCount)
        
        self.business = business
    }

    // MARK: - Actions

    public func calculateEta() -> SignalProducer<NSTimeInterval, NSError> {
        return geoLocationService.calculateETA(CLLocation(latitude: business.address.geoLocation.latitude, longitude: business.address.geoLocation.longitude))
            .on(
                next: { interval in
                    let minute = Int(ceil(interval / 60))
                    self._eta.value = "\(minute)分钟"
                },
                failed: { FeaturedLogError($0.description) }
            )
    }
    
    public func fetchCoverImage() -> SignalProducer<UIImage, NSError> {
        return imageService.getImage(business.coverImage)
            .on(
                next: { self._coverImage.value = $0 },
                failed: { FeaturedLogError($0.description) }
            )
    }
}

