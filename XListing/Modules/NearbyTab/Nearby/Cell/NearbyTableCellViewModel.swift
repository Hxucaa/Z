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

public final class NearbyTableCellViewModel: BasicBusinessInfoViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    private let _coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    public var coverImage: AnyProperty<UIImage?> {
        return AnyProperty(_coverImage)
    }
    
    private let _participation: MutableProperty<String>
    public var participation: AnyProperty<String> {
        return AnyProperty(_participation)
    }
    
    private let _businessHours: ConstantProperty<String> = ConstantProperty("今天 10:00AM - 10:00PM")
    public var businessHours: AnyProperty<String> {
        return AnyProperty(_businessHours)
    }
    
    private let _annotation: ConstantProperty<MKPointAnnotation>
    public var annotation: AnyProperty<MKPointAnnotation> {
        return AnyProperty(_annotation)
    }
    
    // MARK: - Properties
    private let business: Business
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let businessLocation: Geolocation
    
    // MARK: - Initializers
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, businessName: String?, city: String?, district: String?, cover: ImageFile?, geolocation: Geolocation?, aaCount: Int, treatCount: Int, toGoCount: Int, business: Business?) {
        
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.business = business!
        
        _participation = MutableProperty("\(aaCount + treatCount + toGoCount)+ 人想去")
        
        businessLocation = geolocation!
            
        let annotation = MKPointAnnotation()
        annotation.coordinate = businessLocation.cllocation.coordinate
        annotation.title = businessName
        self._annotation = ConstantProperty(annotation)
        
        super.init(geoLocationService: geoLocationService, businessName: businessName, city: city, district: district, price: 0, geolocation: geolocation)
    }

    public required init(geoLocationService: IGeoLocationService, businessName: String?, city: String?, district: String?, price: Int?, geolocation: Geolocation?) {
        fatalError("init(geoLocationService:businessName:city:district:price:geolocation:) has not been implemented")
    }
    
    // MARK: - Setups
    
    // MARK: - API
    public func getCoverImage() -> SignalProducer<Void, NSError> {
        if let url = business.cover_?.url, nsurl = NSURL(string: url) {
            return imageService.getImage(nsurl)
                .on(next: {
                    self._coverImage.value = $0
                })
                .map { _ in return }
        }
        else {
            return SignalProducer<Void, NSError>.empty
        }
    }
}