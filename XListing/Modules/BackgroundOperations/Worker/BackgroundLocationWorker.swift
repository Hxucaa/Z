//
//  BackgroundLocationWorker.swift
//  XListing
//
//  Created by William Qi on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import CoreLocation

public struct BackgroundLocationWorker : IBackgroundLocationWorker {
    
    private let geoService: IGeoLocationService
    
    public init(geoService: IGeoLocationService) {
        self.geoService = geoService
    }
    
    public func startLocationUpdates() {
        println("location updates started");
        geoService.locationManager.startMonitoringSignificantLocationChanges()
    }
    

    
}