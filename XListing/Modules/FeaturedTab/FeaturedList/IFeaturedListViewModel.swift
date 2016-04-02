//
//  IFeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray

protocol IFeaturedListViewModel {
    
    // MARK: - Outputs
    
//    var collectionDataSource: ReactiveArray<BusinessInfo> { get }
    var collectionDataSource: MutableProperty<[BusinessInfo]> { get }
    
//    init(dep: (businessRepository: IBusinessRepository, userRepository: IUserRepository, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService), input: (didSelectRow: SignalProducer<NSIndexPath, NoError>, test: Int))
    
//    func pushSocialBusinessModule(section: Int)
}