//
//  GeoLocationService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import CoreLocation

public final class GeoLocationService : IGeoLocationService {
    
    private final class LocationManager : NSObject, CLLocationManagerDelegate {
        
        private let locationManager = CLLocationManager()
        
        private override init() {
            super.init()
            locationManager.delegate = self
        }
    }
    
    private let locationManager = LocationManager()
    
    public func getCurrentLocation() -> SignalProducer<CLLocation, NSError> {
        return SignalProducer<CLLocation, NSError> { observer, disposable in
            // get current location
            AVGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
                if error == nil {
                    observer.sendNext(CLLocation(latitude: geopoint!.latitude, longitude: geopoint!.longitude))
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }
    
    public func getCurrentGeoPoint() -> SignalProducer<AVGeoPoint, NSError> {
        return SignalProducer { observer, disposable in
            // get current location
            AVGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
                if error == nil {
                    observer.sendNext(geopoint)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }
    
    /**
    Calculate ETA from current location to destination location. Current location is automatically acquired.
    
    - parameter destination: Destination location.
    
    - returns: A SignalProducer containing time interval expressed in NSTimeInterval.
    */
    public func calculateETA(destination: CLLocation) -> SignalProducer<NSTimeInterval, NSError> {
        return calETA(destination, currentLocation: nil)
    }
    
    /**
    Calculate ETA from current location to destination location. User has to provide current location.
    
    - parameter destination:     Destination location.
    - parameter currentLocation: Current location provided by user.
    
    - returns: A SignalProducer containing time interval expressed in NSTimeInterval.
    */
    public func calculateETA(destination: CLLocation, currentLocation: CLLocation) -> SignalProducer<NSTimeInterval, NSError> {
        return calETA(destination, currentLocation: currentLocation)
    }
    
    private func calETA(destination: CLLocation, currentLocation: CLLocation? = nil) -> SignalProducer<NSTimeInterval, NSError> {
        
        requestWhenInUseAuthorization()
        
        return SignalProducer<NSTimeInterval, NSError> { observer, disposable in
            let request = MKDirectionsRequest()
            if let currentLocation = currentLocation {
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate, addressDictionary: nil))
            }
            else {
                request.source = MKMapItem.mapItemForCurrentLocation()
            }
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = false
            request.transportType = MKDirectionsTransportType.Automobile
            
            let direction = MKDirections(request: request)
            direction.calculateETAWithCompletionHandler { (response, error) -> Void in
                if error == nil {
                    observer.sendNext(response!.expectedTravelTime)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error!)
                }
            }
        }
    }
    
    private func requestWhenInUseAuthorization() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.locationManager.requestWhenInUseAuthorization()
        }
    }
}