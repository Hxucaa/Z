//
//  IGeoLocationService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactiveCocoa
import MapKit
import CoreLocation
import AVOSCloud

public protocol IGeoLocationService {
    var defaultGeoPoint: AVGeoPoint! { get }
    func getCurrentLocation() -> Task<Int, CLLocation, NSError>
    func getCurrentLocationSignal() -> SignalProducer<CLLocation, NSError>
    func getCurrentGeoPoint() -> Task<Int, AVGeoPoint, NSError>
    func calculateETA(destination: CLLocation) -> SignalProducer<NSTimeInterval, NSError>
    func calculateETA(destination: CLLocation, currentLocation: CLLocation) -> SignalProducer<NSTimeInterval, NSError>
}