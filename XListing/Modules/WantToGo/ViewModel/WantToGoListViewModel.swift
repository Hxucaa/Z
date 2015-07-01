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

public struct WantToGoListViewModel : IWantToGoListViewModel {
    // MARK: - Public
    
    // MARK: Input
    
    // MARK: Output
    public let wantToGoViewModelArr: MutableProperty<[WantToGoViewModel]> = MutableProperty([WantToGoViewModel]())
    public let fetchingData: MutableProperty<Bool> = MutableProperty(false)
    
    // MARK: Actions
    
    // MARK: API
    public func getWantToGoUsers() -> SignalProducer<[WantToGoViewModel], NSError> {
        // TODO: Replace dummy data with actual API call
        let dummyWTG1 = WantToGoViewModel(participationService: participationService, profilePicture: nil, displayName: "James Liu", horoscope: "Pony", ageGroup: "swag")
        let dummyWTG2 = WantToGoViewModel(participationService: participationService, profilePicture: nil, displayName: "First Last", horoscope: "Animal", ageGroup: "Group")
        let WTGArray = [dummyWTG1, dummyWTG2]
        
        return SignalProducer { sink, disposable in
            sendNext(sink, WTGArray)
        }
    }
    
    // MARK: Initializers
    public init(router: IRouter, userService: IUserService, participationService: IParticipationService, business: Business) {
        self.router = router
        self.userService = userService
        self.participationService = participationService
        self.business = business
        
        getWantToGoUsers()
            |> start(next: { data in
                self.wantToGoViewModelArr.put(data)
            })
    }
    
    // MARK: - Private
    
    // MARK: Private Variables
    private let router: IRouter
    private let userService: IUserService
    private let participationService: IParticipationService
    private let business: Business
}

