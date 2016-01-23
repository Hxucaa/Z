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

public final class NearbyTableCellViewModel: BasicBusinessInfoViewModel, INearbyTableCellViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
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
    
    // MARK: - Initializers
    public override init(geoLocationService: IGeoLocationService, imageService: IImageService, business: Business) {
        
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.business = business
        
        _participation = MutableProperty("\(business.aaCount + business.treatCount + business.toGoCount)+ 人想去")
            
        let annotation = MKPointAnnotation()
        annotation.coordinate = business.address.geoLocation.cllocation.coordinate
        annotation.title = business.name
        self._annotation = ConstantProperty(annotation)
        
        super.init(geoLocationService: geoLocationService, imageService: imageService, business: business)
    }
    
    // MARK: - Setups
    
    // MARK: - API
}