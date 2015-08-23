//
//  INearbyViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit

public protocol INearbyViewModel {
    var businessViewModelArr: MutableProperty<[NearbyTableCellViewModel]> { get }
    var currentLocation: SignalProducer<CLLocation, NSError> { get }
    init(router: IRouter, businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService)
    func pushDetailModule(section: Int)
    func pushProfileModule()
    func getBusinessesWithMap(centreLat: CLLocationDegrees, centreLong: CLLocationDegrees, radius: Double) -> SignalProducer<[NearbyTableCellViewModel], NSError> 
}