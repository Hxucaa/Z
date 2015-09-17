//
//  ISocialBusinessHeaderViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public protocol ISocialBusinessHeaderViewModel : class {
    
    // MARK: - Outputs
    var coverImage: PropertyOf<UIImage?> { get }
    var businessName: PropertyOf<String> { get }
    var location: PropertyOf<String> { get }
    var eta: PropertyOf<String?> { get }
    
    // MARK: - Initializers
    init(geoLocationService: IGeoLocationService, imageService: IImageService, imageURL: NSURL?, businessName: String?, city: String?, geopoint: Geolocation?)
}