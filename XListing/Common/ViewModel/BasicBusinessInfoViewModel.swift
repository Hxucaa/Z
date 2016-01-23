//
//  BasicBusinessInfoViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Swiftz
import ReactiveCocoa
import AVOSCloud

public class BasicBusinessInfoViewModel : IBasicBusinessInfoViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs

//    private let _name: ConstantProperty<String>
//    public var name: AnyProperty<String> {
//        return AnyProperty(_name)
//    }
    public let name: SignalProducer<String, NoError>
    public let phone: SignalProducer<String, NoError>
    public let email: SignalProducer<String?, NoError>
    public let websiteUrl: SignalProducer<String?, NoError>
    public let district: SignalProducer<String?, NoError>
    public let city: SignalProducer<String, NoError>
    public let province: SignalProducer<String, NoError>
    public let coverImageUrl: SignalProducer<String, NoError>
    
    private let _coverImage: MutableProperty<UIImage> = MutableProperty(ImageAsset.placeholder)
    public var coverImage: AnyProperty<UIImage> {
        return AnyProperty(_coverImage)
    }
    
//    public var coverImageDataBase64: SignalProducer<String, NoError> {
//        // TODO: may need to cache this?? for performance reason
//        
//        return coverImage.producer
//            .map { UIImageJPEGRepresentation($0, 1.0)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength) }
//    }
    
    public let description: SignalProducer<String?, NoError>
    public let averagePrice: SignalProducer<String, NoError>
    public let aaCount: SignalProducer<Int, NoError>
    public let treatCount: SignalProducer<Int, NoError>
    public let toGoCount: SignalProducer<Int, NoError>
    
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
        
        name = SignalProducer(value: business.name)
        phone = SignalProducer(value: business.phone)
        email = SignalProducer(value: business.email)
        websiteUrl = SignalProducer(value: business.websiteUrl)
        district = SignalProducer(value: business.address.district.regionNameC)
        city = SignalProducer(value: business.address.city.regionNameC)
        province = SignalProducer(value: business.address.province.regionNameC)
        coverImageUrl = SignalProducer(value: business.coverImage.url)
        description = SignalProducer(value: business.descript)
        averagePrice = SignalProducer(value: "")
        aaCount = SignalProducer(value: business.aaCount)
        treatCount = SignalProducer(value: business.treatCount)
        toGoCount = SignalProducer(value: business.toGoCount)
        
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

