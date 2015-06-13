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
    public var navParams: SignalProducer<(MKPointAnnotation, MKCoordinateRegion), NSError> {
        return self.geoLocationService.getCurrentLocationSignal()
            |> map { current -> (MKPointAnnotation, MKCoordinateRegion) in
                let anno = self.annotation.value.coordinate
                let distance = CLLocation(latitude: anno.latitude, longitude: anno.longitude).distanceFromLocation(current)
                let spanFactor = distance / 55000.00
                let span = MKCoordinateSpanMake(spanFactor, spanFactor)
                let region = MKCoordinateRegion(center: anno, span: span)
                return (self.annotation.value, region)
        }
    }
    
    // MARK: Outputs
    private let annotation: ConstantProperty<MKPointAnnotation>
    
    public init(geoLocationService: IGeoLocationService, annotation: MKPointAnnotation) {
        self.geoLocationService = geoLocationService
        
        self.annotation = ConstantProperty(annotation)
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
}
