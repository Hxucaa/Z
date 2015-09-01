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

public final class ProfileViewModel : IProfileViewModel {
    
    public let nickname: MutableProperty<String> = MutableProperty("")
    public let user = MutableProperty<User?>(nil)
    public let profileHeaderViewModel = MutableProperty<ProfileHeaderViewModel?>(nil)
    
    // MARK: Private variables
    private let businessService: IBusinessService
    private let participationService: IParticipationService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    private let participationArr: MutableProperty<[Participation]> = MutableProperty([Participation]())
    
    
    public let profileBusinessViewModelArr: MutableProperty<[ProfileBusinessViewModel]> = MutableProperty([ProfileBusinessViewModel]())
    public let fetchingData: MutableProperty<Bool> = MutableProperty(false)
    private let businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
    
    
    public init(participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService) {
        self.participationService = participationService
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService

        
        self.userService.currentLoggedInUser()
            |> start(
                next: { user in
                    self.user.put(user)
                    var viewmodel = ProfileHeaderViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, name: user.nickname, city: "", district: "", horoscope: user.horoscope, ageGroup: user.ageGroup, cover: user.profileImg, geopoint: user.latestLocation)
                    self.profileHeaderViewModel.put(viewmodel)
                    self.getParticipations(user)
                        |> start()
                }
        )
    }
    
    
    private func getParticipations(user : User) -> SignalProducer<[ProfileBusinessViewModel], NSError> {
        let query = Participation.query()!
        typealias Property = Participation.Property
        query.whereKey(Property.User.rawValue, equalTo: user)
        query.includeKey(Property.Business.rawValue)
        
        return participationService.findBy(query)
            |> on(next: { participations in
                self.fetchingData.put(true)
                self.participationArr.put(participations)
                self.businessArr.put(participations.map { $0.business })
            })
            |> map { participations -> [ProfileBusinessViewModel] in

                // map participation to its view model
                return participations.map {
                    let business = $0.business
                    let viewmodel = ProfileBusinessViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: business.nameSChinese, city: business.city, district: business.district, cover: business.cover, geopoint: business.geopoint, participationCount: business.wantToGoCounter)
                    return viewmodel
                }
            }
            |> on(
                next: { response in
                    self.profileBusinessViewModelArr.put(response)
                    self.fetchingData.put(false)
                },
                error: { ProfileLogError($0.customErrorDescription) }
            )
    }
    
    public func undoParticipation(index: Int) -> SignalProducer<Bool, NSError>{
        return participationService.delete(participationArr.value[index])
            |> on(
                next: { _ in
                    ProfileLogInfo("participation backend completed")
                    self.participationArr.value.removeAtIndex(index)
                }
            )
    
    }
    
    public func pushDetailModule(section: Int) {
//        router.pushDetail(businessArr.value[section])
    }
    
    public func presentProfileEditModule() {
//        router.presentProfileEdit(user.value!, completion: nil)
    }
}
