//
//  DetailNavigationMapViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit

public struct DetailNavigationMapViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    public let annotation: ConstantProperty<MKPointAnnotation?>
    public let region = MutableProperty<MKCoordinateRegion?>(nil)
    
    // MARK: - Properties
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    
    // MARK: - Initializers
    public init(geoLocationService: IGeoLocationService, businessName: String?, geolocation: Geolocation?) {
        self.geoLocationService = geoLocationService
        
        if let coordinate = geolocation?.cllocation.coordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = businessName
            self.annotation = ConstantProperty(annotation)
            
            
            region <~ self.geoLocationService.getCurrentLocation()
                .map { current -> MKCoordinateRegion? in
                    let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distanceFromLocation(current)
                    let spanFactor = distance / 45000.00
                    let span = MKCoordinateSpanMake(spanFactor, spanFactor)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    return region
                }
                .flatMapError { error in
                    return SignalProducer<MKCoordinateRegion?, NoError>.empty
            }
            
        }
        else {
            self.annotation = ConstantProperty(nil)
        }
        
    }
    
}
