//
//  IGeoLocationService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import RxSwift
import CoreLocation
import AVOSCloud

public protocol IGeoLocationService : class {
    func getCurrentLocation() -> SignalProducer<CLLocation, NSError>
    func rx_getCurrentGeoPoint() -> Observable<CLLocation>
    func getCurrentGeoPoint() -> SignalProducer<AVGeoPoint, NSError>
    /**
     Calculate ETA from current location to destination location. Current location is automatically acquired.
     
     - parameter destination: Destination location.
     
     - returns: A observable sequence containing time interval expressed in NSTimeInterval.
     */
    func calculateETA(destination: CLLocation) -> Observable<NSTimeInterval>
    
    /**
     Calculate ETA from current location to destination location. User has to provide current location.
     
     - parameter destination:     Destination location.
     - parameter currentLocation: Current location provided by user.
     
     - returns: A observable sequence containing time interval expressed in NSTimeInterval.
     */
    func calculateETA(destination: CLLocation, currentLocation: CLLocation) -> Observable<NSTimeInterval>
}