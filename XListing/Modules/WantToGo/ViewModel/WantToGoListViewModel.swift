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

private let 启动无限scrolling参数 = 0.4

public final class WantToGoListViewModel : IWantToGoListViewModel {
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
                    return WantToGoViewModel(participationService: self.participationService, imageService: self.imageService, profilePicture: $0.user.profileImg, displayName: $0.user.nickname, horoscope: $0.user.horoscope, ageGroup: $0.user.ageGroup, gender: $0.user.gender)
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
    
    public func fetchMoreData() -> SignalProducer<Void, NSError> {
        return getWantToGoUsers()
            |> map { _ in }
    }
    
    public func refreshData() -> SignalProducer<Void, NSError> {
        return getWantToGoUsers()
            |> map { _ in }
    }
    
    /**
    Return a boolean value indicating whether there are still plenty of data for display.
    
    :param: index The index of the currently displaying Business.
    
    :returns: A Boolean value.
    */
    public func havePlentyOfData(index: Int) -> Bool {
        return Double(index) < Double(wantToGoViewModelArr.value.count) - Double(Constants.PAGINATION_LIMIT) * Double(启动无限scrolling参数)
    }
    

    
    // MARK: Initializers
    public init(router: IRouter, userService: IUserService, participationService: IParticipationService, imageService: IImageService, business: Business) {
        self.router = router
        self.userService = userService
        self.participationService = participationService
        self.imageService = imageService
        self.business = business
        
        getWantToGoUsers()
            |> start()
    }
    
    // MARK: - Private
    
    // MARK: Private Variables
    private let router: IRouter
    private let userService: IUserService
    private let participationService: IParticipationService
    private let imageService: IImageService
    private let business: Business
    private let participationArr: MutableProperty<[Participation]> = MutableProperty([Participation]())
    private let allUsersArr: MutableProperty<[WantToGoViewModel]> = MutableProperty([WantToGoViewModel]())
}

