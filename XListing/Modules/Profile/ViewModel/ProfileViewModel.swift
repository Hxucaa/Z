//
// ProfileViewModel.swift
// XListing
//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import Dollar

public struct ProfileViewModel : IProfileViewModel {
    
    public var nickname: MutableProperty<String> = MutableProperty("")
    public var profileEditViewModel: ProfileEditViewModel
    public var user: MutableProperty<User> = MutableProperty(User())
    
    
    // MARK: Private variables
    private let router: IRouter
    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    private var businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
    
    
    public let profileBusinessViewModelArr: MutableProperty<[ProfileBusinessViewModel]> = MutableProperty([ProfileBusinessViewModel]())
    public let fetchingData: MutableProperty<Bool> = MutableProperty(false)
    
    
    public init(router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService) {
        self.router = router
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService
        
        profileEditViewModel = ProfileEditViewModel(userService: self.userService)
        
        self.userService.currentLoggedInUser()
            |> start(
                next: { user in
                    self.user = MutableProperty(user)
                }
        )
        
        self.getFeaturedBusinesses()
            |> start()
    }
    
    
    
    public func getFeaturedBusinesses() -> SignalProducer<[ProfileBusinessViewModel], NSError> {
        let query = Business.query()!
        query.whereKey(Business.Property.Featured.rawValue, equalTo: true)
        
        return businessService.findBy(query)
            |> on(next: { businesses in
                self.fetchingData.put(true)
            })
            |> map { businesses -> [ProfileBusinessViewModel] in
                // shuffle and save the business models
                self.businessArr.put($.shuffle(businesses))
                
                // map the business models to viewmodels
                return self.businessArr.value.map {
                    ProfileBusinessViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: $0.nameSChinese, city: $0.city, district: $0.district, cover: $0.cover, geopoint: $0.geopoint, participationCount: $0.wantToGoCounter)
                }
            }
            |> on(
                next: { response in
                    self.fetchingData.put(false)
                    self.profileBusinessViewModelArr.put(response)
                },
                error: { FeaturedLogError($0.description)}
        )
    }
    
    
}
