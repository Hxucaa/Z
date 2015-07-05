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
        let query = Participation.query()!
        query.whereKey(Participation.Property.Business.rawValue, equalTo: business.objectId)
        query.includeKey(Participation.Property.User.rawValue)
        
        return participationService.findBy(query)
            |> on(next: { participations in
                self.fetchingData.put(true)
            })
            |> map { participations -> [WantToGoViewModel] in
                self.participationArr.put($.shuffle(participations))
                
                return self.participationArr.value.map {
                    WantToGoViewModel(participationService: self.participationService, profilePicture: nil, displayName: "First Last", horoscope: "Leo", ageGroup: "90s")
                }
            }
            |> on(
                next: { response in
                    self.fetchingData.put(false)
                    self.wantToGoViewModelArr.put(response)
            },
                error: {FeaturedLogError($0.description)}
        )
    }
    
    
    
//        let WTGUsers = [WantToGoViewModel]()
//        
//        let dummyWTG1 = WantToGoViewModel(participationService: participationService, profilePicture: nil, displayName: "James Liu", horoscope: "Pony", ageGroup: "swag")
//        let dummyWTG2 = WantToGoViewModel(participationService: participationService, profilePicture: nil, displayName: "First Last", horoscope: "Animal", ageGroup: "Group")
//        let dummyWTG3 = WantToGoViewModel(participationService: participationService, profilePicture: nil, displayName: "William Qi", horoscope: "Leo",
//            ageGroup: "90s")
//        let WTGArray = [dummyWTG1, dummyWTG2, dummyWTG3]
//        
//        return SignalProducer { sink, disposable in
//            sendNext(sink, WTGArray)
//        }
//    }
    
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
}

