//
//  DetailAddressAndMapViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import MapKit

public struct DetailAddressAndMapViewModel {
    
    // MARK: - Public
    
    // MARK: Outputs
    public let fullAddress: ConstantProperty<String>
    public let annotation: ConstantProperty<MKPointAnnotation>
    public let cellMapRegion: ConstantProperty<MKCoordinateRegion>
    public private(set) lazy var detailNavigationMapViewModel: DetailNavigationMapViewModel = DetailNavigationMapViewModel(geoLocationService: self.geoLocationService, annotation: self.annotation.value)
    
    // MARK: API
    
    // MARK: Initializers
    public init(geoLocationService: IGeoLocationService, businessName: String?, address: String?, city: String?, state: String?, geopoint: AVGeoPoint?) {
        self.geoLocationService = geoLocationService
        
        self.fullAddress = ConstantProperty<String>("   \u{f124}   \(address!), \(city!), \(state!)")
        
        let cllocation = CLLocation(latitude: geopoint!.latitude, longitude: geopoint!.longitude)
        businessLocation = ConstantProperty(cllocation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cllocation.coordinate
        annotation.title = businessName
//            annotation.subtitle = 
        self.annotation = ConstantProperty(annotation)
        
        /**
        *  region for the map in cell
        */
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: cllocation.coordinate, span: span)
        self.cellMapRegion = ConstantProperty(region)
        
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    private let businessLocation: ConstantProperty<CLLocation>
}