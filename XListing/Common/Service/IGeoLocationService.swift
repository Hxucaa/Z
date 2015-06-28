//
//  IGeoLocationService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import CoreLocation
import AVOSCloud

public protocol IGeoLocationService {
    func getCurrentLocation() -> SignalProducer<CLLocation, NSError>
    func getCurrentGeoPoint() -> SignalProducer<AVGeoPoint, NSError>
    func calculateETA(destination: CLLocation) -> SignalProducer<NSTimeInterval, NSError>
    func calculateETA(destination: CLLocation, currentLocation: CLLocation) -> SignalProducer<NSTimeInterval, NSError>
}