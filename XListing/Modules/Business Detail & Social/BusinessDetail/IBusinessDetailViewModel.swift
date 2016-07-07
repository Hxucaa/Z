//
//  IBusinessDetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-09.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

protocol IBusinessDetailViewModel : class {
    
    // MARK: - Outputs
    var businessName: String { get }
    var phoneDisplay: String { get }
    var websiteDisplay: String { get }
    var descriptor: String { get }
    var fullAddress: String { get }
    var annotation: MKPointAnnotation { get }
    var cellMapRegion: MKCoordinateRegion { get }
    var webSiteURL: NSURL? { get }
    var businessImageURL: NSURL? { get }
    var city: String { get }
    var meAndBusinessRegion: Driver<MKCoordinateRegion> { get }
    var businessHour: String { get }
    var callStatus: Observable<Bool> { get }
    func calculateEta() -> Driver<String>
}