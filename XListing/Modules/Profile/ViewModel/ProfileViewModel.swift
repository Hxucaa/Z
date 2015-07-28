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
    public let profileHeaderViewModel = MutableProperty<ProfileHeaderViewModel?>(nil)
    
    // MARK: Private variables
    private let router: IRouter
    private let businessService: IBusinessService
    private let participationService: IParticipationService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    private var participationArr: MutableProperty<[Participation]> = MutableProperty([Participation]())
    
    
    public let profileBusinessViewModelArr: MutableProperty<[ProfileBusinessViewModel]> = MutableProperty([ProfileBusinessViewModel]())
    public let fetchingData: MutableProperty<Bool> = MutableProperty(false)
    
    
    public init(router: IRouter, participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService) {
        self.router = router
        self.participationService = participationService
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
                    BOLogVerbose("\(user.toString())")
                    var viewmodel = ProfileHeaderViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, name: user.nickname, city: "", district: "", horoscope: user.horoscope, ageGroup: user.ageGroup, cover: user.profileImg, geopoint: user.latestLocation)
                    self.profileHeaderViewModel.put(viewmodel)
                    self.getParticipations(user)
                        |> start()
                }
        )
    }
    
    
//    public func getFeaturedBusinesses() -> SignalProducer<[FeaturedBusinessViewModel], NSError> {
//        let query = Business.query()!
//        query.whereKey(Business.Property.Featured.rawValue, equalTo: true)
//        
//        return businessService.findBy(query)
//            |> on(next: { businesses in
//                self.fetchingData.put(true)
//            })
//            |> map { businesses -> [FeaturedBusinessViewModel] in
//                // shuffle and save the business models
//                self.businessArr.put($.shuffle(businesses))
//                
//                // map the business models to viewmodels
//                return self.businessArr.value.map {
//                    FeaturedBusinessViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: $0.nameSChinese, city: $0.city, district: $0.district, cover: $0.cover, geopoint: $0.geopoint, participationCount: $0.wantToGoCounter)
//                }
//            }
//            |> on(
//                next: { response in
//                    self.fetchingData.put(false)
//                    self.featuredBusinessViewModelArr.put(response)
//                },
//                error: { FeaturedLogError($0.description) }
//        )
//    }
//    
    
    
    public func getParticipations(user : User) -> SignalProducer<[ProfileBusinessViewModel], NSError> {
        let query = Participation.query()!
        query.whereKey(Participation.Property.User.rawValue, equalTo: user)
        query.includeKey("business")
        BOLogVerbose("getParticipations called")
        return participationService.findBy(query)
            |> on(next: { participations in
                self.fetchingData.put(true)
            })
            |> map { participations -> [ProfileBusinessViewModel] in
                // shuffle and save the participations
                self.participationArr.put($.shuffle(participations))
                BOLogVerbose("participations fetched \(participations.count)")

                // map the business models to viewmodels
                return self.participationArr.value.map {
                    var viewmodel: ProfileBusinessViewModel = ProfileBusinessViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: "", city: "", district: "", cover: nil, geopoint: nil, participationCount: 0)
                    if let business = $0.objectForKey("business") as? Business{
                        viewmodel = ProfileBusinessViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: business.nameSChinese, city: business.city, district: business.district, cover: business.cover, geopoint: business.geopoint, participationCount: business.wantToGoCounter)
                    }
                    return viewmodel
                }
            }
            |> on(
                next: { response in
                    self.profileBusinessViewModelArr.put(response)
                    self.fetchingData.put(false)
                },
                error: { FeaturedLogError($0.description)}
        )
    }
}
