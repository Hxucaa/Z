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
    var coverImage: AnyProperty<UIImage?> { get }
    var name: AnyProperty<String> { get }
    var location: AnyProperty<String> { get }
    var eta: AnyProperty<String?> { get }
    
    // MARK: - Initializers
    init(geoLocationService: IGeoLocationService, imageService: IImageService, coverImage: ImageFile, name: String, city: City, geolocation: Geolocation)
}