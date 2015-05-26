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

public class FeaturedListViewModel : IFeaturedListViewModel {
    public let businessDynamicArr = DynamicArray()
    
    private let navigator: INavigator
    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    
    private var businessModelArr: [Business]!
    
    public init(navigator: INavigator, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService) {
        self.navigator = navigator
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
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
                            let vm = FeaturedListCellViewModel(business: bus, currentLocation: location)
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
                            let vm = FeaturedListCellViewModel(business: bus)
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
        navigator.navigateToNearbyModule()
    }
    
    public func pushDetailModule(section: Int) {
        let model = businessModelArr[section]
        
        navigator.navigateToDetailModule(["BusinessModel" : model])
    }
    
    public func pushProfileModule() {
        navigator.navigateToProfileModule()
    }
    
    public func presentAccountModule() {
        if userService.currentUser()?.birthday == nil {
            navigator.navigateToAccountModule()
        }
    }
}