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
    
    // MARK: - Public
    public let annotation: ConstantProperty<MKPointAnnotation>
    public let region = MutableProperty<MKCoordinateRegion?>(nil)
    
    // MARK: Outputs
    
    public init(geoLocationService: IGeoLocationService, businessName: String?, businessLocation: CLLocation) {
        self.geoLocationService = geoLocationService
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = businessLocation.coordinate
        annotation.title = businessName
        
        self.annotation = ConstantProperty(annotation)
        
        region <~ self.geoLocationService.getCurrentLocation()
            |> map { current -> MKCoordinateRegion? in
                let coordinate = annotation.coordinate
                let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distanceFromLocation(current)
                let spanFactor = distance / 45000.00
                let span = MKCoordinateSpanMake(spanFactor, spanFactor)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                return region
            }
            |> catch { error in
                return SignalProducer<MKCoordinateRegion?, NoError>.empty
            }
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
}
