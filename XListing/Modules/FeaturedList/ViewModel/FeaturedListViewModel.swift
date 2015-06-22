//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public struct FeaturedListViewModel : IFeaturedListViewModel {
    
    public let featuredBusinessViewModelArr: MutableProperty<[FeaturedBusinessViewModel]> = MutableProperty([FeaturedBusinessViewModel]())
    
    public init(router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService) {
        self.router = router
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        
        getFeaturedBusinesses()
    }
    
    /**
    Retrieve featured business from database
    */
    private func getFeaturedBusinesses() {
        let query = Business.query()!
        query.whereKey("featured", equalTo: true)
        
        businessService.findBySignal(query)
            |> on(next: { businesses in
                self.businessArr.put(businesses)
            })
            |> map { businesses -> [FeaturedBusinessViewModel] in
                return businesses.map { FeaturedBusinessViewModel(geoLocationService: self.geoLocationService, businessName: $0.nameSChinese, city: $0.city, district: $0.district, cover: $0.cover, geopoint: $0.geopoint) }
            }
            |> start(
                next: { response in
                    self.featuredBusinessViewModelArr.put(response)
                },
                error: { FeaturedLogError($0.description) }
            )
    }
    
    private let router: IRouter
    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private var businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
    
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
        router.pushDetail(businessArr.value[section])
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