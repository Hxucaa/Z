//
//  BackgroundLocationWorker.swift
//  XListing
//
//  Created by William Qi on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import CoreLocation

public class BackgroundLocationWorker : NSObject, IBackgroundLocationWorker, CLLocationManagerDelegate {
    
    private let userService: IUserService
    private let geoService: IGeoLocationService
    
    public required init(userService: IUserService, geoService: IGeoLocationService) {
        self.userService = userService
        self.geoService = geoService
    }
    
    public func startLocationUpdates() {
        BOLogInfo("Background location updates started");
        geoService.locationManager.delegate = self
        geoService.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        let user = userService.currentUser()
        let latestLocation = PFGeoPoint(location: newLocation)
        
        user!.latestLocation = latestLocation
        
        let saveLocationTask = self.userService.save(user!)
            .success { success-> Bool in
                BOLogInfo("User location updated")
                return true
            }
        .failure({(error, isCancelled) -> Bool in
            BOLogInfo("Location update failed!")
            return false
        })
    }

    
}