//
//  INearbyTableCellViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-11-05.
//  Copyright © 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol INearbyTableCellViewModel: class, IBasicBusinessInfoViewModel {
    
    // MARK: - Outputs
    var participation: AnyProperty<String> { get }
    var businessHours: AnyProperty<String> { get }
    var annotation: AnyProperty<MKPointAnnotation> { get }
    
    // MARK: - Initializers
    init(geoLocationService: IGeoLocationService, imageService: IImageService, business: Business)
    
    // MARK: - API
}