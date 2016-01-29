//
//  DetailAddressAndMapViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit

public final class DetailAddressAndMapViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    private let _fullAddress: ConstantProperty<String>
    public var fullAddress: AnyProperty<String> {
        return AnyProperty(_fullAddress)
    }
    private let _annotation: ConstantProperty<MKPointAnnotation>
    public var annotation: AnyProperty<MKPointAnnotation> {
        return AnyProperty(_annotation)
    }
    private let _cellMapRegion: ConstantProperty<MKCoordinateRegion>
    public var cellMapRegion: AnyProperty<MKCoordinateRegion> {
        return AnyProperty(_cellMapRegion)
    }
    
    // MARK: - Properties
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    private let businessLocation: Geolocation?
    
    // MARK: - API
    
    // MARK: Initializers
    public init(geoLocationService: IGeoLocationService, name: String, street: String, city: City, province: Province, geolocation: Geolocation) {
        self.geoLocationService = geoLocationService
        
        self._fullAddress = ConstantProperty<String>("\(street), \(city.regionNameC), \(province.regionNameC)")
        
        businessLocation = geolocation
        
        let location = geolocation.cllocation.coordinate
            
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = name
        self._annotation = ConstantProperty(annotation)
        
        /**
        *  region for the map in cell
        */
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        self._cellMapRegion = ConstantProperty(region)
    }
}