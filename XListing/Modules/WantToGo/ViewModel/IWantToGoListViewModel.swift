//
//  IWantToGoListViewModel.swift
//  XListing
//
//  Created by William Qi on 2015-06-26.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IWantToGoListViewModel {
    var wantToGoViewModelArr: MutableProperty<[WantToGoViewModel]> { get }
    init(router: IRouter, userService: IUserService, participationService: IParticipationService, business: Business)
    func getWantToGoUsers() -> SignalProducer<[WantToGoViewModel], NSError>
    func showMaleUsers()
    func showFemaleUsers()
}
