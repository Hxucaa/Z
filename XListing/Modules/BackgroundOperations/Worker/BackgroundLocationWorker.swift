//
//  BackgroundLocationWorker.swift
//  XListing
//
//  Created by William Qi on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import CoreLocation
import AVOSCloud

public final class BackgroundLocationWorker : NSObject, IBackgroundLocationWorker, CLLocationManagerDelegate {
    
    private let userService: IUserService
    private let userDefaultsService: IUserDefaultsService
    
    public required init(userService: IUserService, userDefaultsService: IUserDefaultsService) {
        self.userService = userService
        self.userDefaultsService = userDefaultsService
    }
    
    private lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    public func startLocationUpdates() {
        BOLogInfo("Background location updates started");
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        let user = userService.currentUser()
        let latestLocation = AVGeoPoint(location: newLocation)
        
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