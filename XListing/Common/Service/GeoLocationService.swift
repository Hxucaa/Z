//
//  GeoLocationService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactiveCocoa
import MapKit
import AVOSCloud
import CoreLocation

public struct GeoLocationService : IGeoLocationService {
    
    public let defaultGeoPoint = AVGeoPoint(latitude: 49.27623, longitude: -123.12941)
    
    public func getCurrentLocation() -> Task<Int, CLLocation, NSError> {
        return Task<Int, CLLocation, NSError> { progress, fulfill, reject, configure in
            // get current location
            AVGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
                if error == nil {
                    let t = geopoint!
                    fulfill(CLLocation(latitude: t.latitude, longitude: t.longitude))
                }
                else {
                    reject(error!)
                }
            }
        }
    }
    
    public func getCurrentLocationSignal() -> SignalProducer<CLLocation, NSError> {
        return SignalProducer<CLLocation, NSError> { sink, disposable in
            // get current location
            AVGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
                if error == nil {
                    sendNext(sink, CLLocation(latitude: geopoint!.latitude, longitude: geopoint!.longitude))
                    sendCompleted(sink)
                }
                else {
                    sendError(sink, error)
                }
            }
        }
    }
    
    public func getCurrentGeoPoint() -> Task<Int, AVGeoPoint, NSError> {
        return Task<Int, AVGeoPoint, NSError> { progress, fulfill, reject, configure in
            // get current location
            AVGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
                if error == nil {
                    
                    fulfill(geopoint!)
                }
                else {
                    reject(error!)
                }
            }
        }
    }
    
    public func calculateETA(destination: CLLocation) -> SignalProducer<NSTimeInterval, NSError> {
        return SignalProducer<NSTimeInterval, NSError> { sink, disposable in
            
            let request = MKDirectionsRequest()
            request.setSource(MKMapItem.mapItemForCurrentLocation())
            request.setDestination(MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate, addressDictionary: nil)))
            request.requestsAlternateRoutes = false
            request.transportType = MKDirectionsTransportType.Automobile
            
            let direction = MKDirections(request: request)
            direction.calculateETAWithCompletionHandler { (response, error) -> Void in
                if error == nil {
                    sendNext(sink, response.expectedTravelTime)
                    sendCompleted(sink)
                }
                else {
                    sendError(sink, error)
                }
            }
        }
    }
}