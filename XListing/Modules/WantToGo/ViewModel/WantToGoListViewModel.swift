//
//  WantToGoListViewModel.swift
//  XListing
//
//  Created by William Qi on 2015-06-26.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import Dollar

public struct WantToGoListViewModel : IWantToGoListViewModel {
    // MARK: - Public
    
    // MARK: Input
    
    // MARK: Output
    public let wantToGoViewModelArr: MutableProperty<[WantToGoViewModel]> = MutableProperty([WantToGoViewModel]())
    public let fetchingData: MutableProperty<Bool> = MutableProperty(false)
    
    // MARK: Actions
    
    // MARK: API
    public func getWantToGoUsers() -> SignalProducer<[WantToGoViewModel], NSError> {
        let query = Participation.query()
        query.whereKey(Participation.Property.Business.rawValue, equalTo: business)
        query.includeKey(Participation.Property.User.rawValue)
        return participationService.findBy(query)
            |> on(next: { participations in
                self.fetchingData.put(true)
            })
            |> map { participations -> [WantToGoViewModel] in
                self.participationArr.put($.shuffle(participations))
                BOLogVerbose("Current Participations: \(participations.0.count)")
                return self.participationArr.value.map{
                    return WantToGoViewModel(participationService: self.participationService, profilePicture: $0.user.profileImg, displayName: $0.user.nickname, horoscope: $0.user.horoscope, ageGroup: $0.user.ageGroup, gender: $0.user.gender)
                    }
            }

            |> on(
                next: { response in
                    self.fetchingData.put(false)
                    self.allUsersArr.put(response)
                    // default segment is male
                    self.showMaleUsers()
            },
                error: {FeaturedLogError($0.description)}
        )
    }
    
    public func showMaleUsers() {
        self.wantToGoViewModelArr.put( allUsersArr.value.filter{
                $0.gender.value == "male"
            }
        )
    }
    
    public func showFemaleUsers() {
        self.wantToGoViewModelArr.put( allUsersArr.value.filter{
            $0.gender.value == "female"
            }
        )
    }
    

    
    // MARK: Initializers
    public init(router: IRouter, userService: IUserService, participationService: IParticipationService, business: Business) {
        self.router = router
        self.userService = userService
        self.participationService = participationService
        self.business = business
        
        getWantToGoUsers()
            |> start()
    }
    
    // MARK: - Private
    
    // MARK: Private Variables
    private let router: IRouter
    private let userService: IUserService
    private let participationService: IParticipationService
    private let business: Business
    private let participationArr: MutableProperty<[Participation]> = MutableProperty([Participation]())
    private let allUsersArr: MutableProperty<[WantToGoViewModel]> = MutableProperty([WantToGoViewModel]())
}

