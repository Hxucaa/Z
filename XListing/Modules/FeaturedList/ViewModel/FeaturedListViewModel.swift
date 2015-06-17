//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit
import AVOSCloud

public final class FeaturedListViewModel : IFeaturedListViewModel {
    public let businessDynamicArr = DynamicArray()
    
    private let router: IRouter
    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    
    private var businessModelArr: [Business]!
    
    public required init(router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService) {
        self.router = router
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
    }
    
    
    public func getBusiness() {
        let query = Business.query()!
        query.whereKey("featured", equalTo: true);
        //TODO: support for offline usage.
        //Fetch current location. Create BusinessViewModel with embedded distance data. And finally add the BusinessViewModels to dynamicArray for the view to consume the signal.
        geoLocationService.getCurrentLocation()
            .success { [unowned self] location -> Task<Int, Void, NSError> in
                return self.businessService.findBy(query)
                    .success { businessDAOArr -> Void in
                        
                        self.businessModelArr = businessDAOArr
                        
                        for bus in businessDAOArr {
                            let vm = FeaturedListCellViewModel(business: bus, currentLocation: location, geoService:self.geoLocationService)
                            // apend BusinessViewModel to DynamicArray for React
                            self.businessDynamicArr.proxy.addObject(vm)
                        }
                        
                        self.shuffle(self.businessDynamicArr.proxy)
                        
                }
            }
            .failure { (error: NSError?, isCancelled: Bool) -> Void in
                return self.businessService.findBy(query)
                    .success { businessDAOArr -> Void in
                        self.businessModelArr = businessDAOArr
                        
                        for bus in businessDAOArr {
                            let vm = FeaturedListCellViewModel(business: bus, geoService: self.geoLocationService)
                            // apend BusinessViewModel to DynamicArray for React
                            self.businessDynamicArr.proxy.addObject(vm)
                        }
                        
                        self.shuffle(self.businessDynamicArr.proxy)
                        
                }
        }
    }
    
    private func shuffle(array: NSMutableArray){
        let c = array.count
        
        if (c > 0){
            for i in 0..<(c - 1) {
                let j = Int(arc4random_uniform(UInt32(c - i))) + i
                swap(&array[i], &array[j])
            }
        }
        return
    }
    
    public func pushNearbyModule() {
        router.pushNearby()
    }
    
    public func pushDetailModule(section: Int) {
        let model = businessModelArr[section]
        router.pushDetail(model)
    }
    
    public func pushProfileModule() {
        router.pushProfile()
    }
    
    public func presentAccountModule() {
        if !userDefaultsService.accountModuleSkipped && !userService.isLoggedInAlready() {
            router.presentAccount(completion: nil)
        }
    }
}