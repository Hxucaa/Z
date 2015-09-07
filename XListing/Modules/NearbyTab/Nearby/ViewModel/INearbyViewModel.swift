//
//  INearbyViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray
import MapKit

public protocol INearbyViewModel {
    var collectionDataSource: ReactiveArray<NearbyTableCellViewModel> { get }
    var currentLocation: SignalProducer<CLLocation, NSError> { get }
    init(businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService)
    func getBusinessesWithMap(searchOrigin: CLLocation, radius: Double) -> SignalProducer<Void, NSError>
    func getAdditionalBusinesses(searchOrigin: CLLocation, skip: Int)  -> SignalProducer<Void, NSError>
    func getInitialBusinesses()  -> SignalProducer<Void, NSError>
    func pushSocialBusinessModule(section: Int)
}