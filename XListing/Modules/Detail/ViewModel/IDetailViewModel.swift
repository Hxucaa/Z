//
//  IDetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit
import MapKit

public protocol IDetailViewModel : class {
    init(router: IRouter, wantToGoService: IWantToGoService, geoLocationService: IGeoLocationService, businessModel: Business)
    var detailBusinessInfoVM: DetailBusinessInfoViewModel! { get set }
    func goingToBusiness(#thisWeek: Bool, thisMonth: Bool, later: Bool) -> Task<Int, WantToGo, NSError>
    func getCurrentLocation() -> Stream<CLLocation>
}