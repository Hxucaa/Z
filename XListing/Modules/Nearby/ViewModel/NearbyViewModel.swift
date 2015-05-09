//
//  NearbyViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public class NearbyViewModel : BaseViewModel, INearbyViewModel {
    
    public var t: Stream<Int>?
    
    public override init(businessService: IBusinessService, geoLocationService: IGeoLocationService) {
        super.init(businessService: businessService, geoLocationService: geoLocationService)
    }
    
    public func getBusiness() -> Stream<Void> {
        let query = BusinessDAO.query()!
        return Stream<Void>.fromTask(super.getBusiness(query))
    }
    
    /**
    Navigate to Detail Module.
    
    :param: businessViewModel The business information to pass along.
    */
    public func pushDetailModule(businessViewModel: BusinessViewModel) {
        NSNotificationCenter.defaultCenter().postNotificationName(NavigationNotificationName.PushDetailModule, object: nil, userInfo: ["viewmodel" : businessViewModel])
    }
    
    /**
    Get current geo location. If location service fails for any reason, use hardcoded geo location instead.
    
    :returns: A Task that contains a geo location.
    */
    public func getCurrentLocation() -> Stream<CLLocation> {
        return Stream<CLLocation>.fromTask(super.getCurrentLocation().failure { [unowned self] (error, isCancelled) -> CLLocation in
            // with hardcoded location
            //TODO: better support for hardcoded location
            println("Location service failed! Using default Vancouver location.")
            return CLLocation(latitude: 49.27623, longitude: -123.12941)
            }
        )
    }
}