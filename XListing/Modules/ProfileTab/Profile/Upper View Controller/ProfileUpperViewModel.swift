//
//  ProfileUpperViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class ProfileUpperViewModel : IProfileUpperViewModel {
    
    // MARK: - Properties
    // MARK: Services
    private let userService: IUserService
    private let imageService: IImageService
    
    // MARK: ViewModels
    
    private let _profileHeaderViewModel = MutableProperty<IProfileHeaderViewModel?>(nil)
    public var profileHeaderViewModel: AnyProperty<IProfileHeaderViewModel?> {
        return AnyProperty(_profileHeaderViewModel)
    }
    
    // MARK: Variables
    private var user: User?
    
    public init(userService: IUserService, imageService: IImageService) {
        self.userService = userService
        self.imageService = imageService
        
    }
    
    // MARK: - API
    
    public func getUserInfo() -> SignalProducer<Void, NSError> {
        return self.userService.currentLoggedInUser()
            .on(next: { user in
                self.user = user
                var viewmodel = ProfileHeaderViewModel(imageService: self.imageService, user: user, nickname: user.nickname, ageGroup: user.ageGroup_, horoscope: user.horoscope_, gender: user.gender_, profileImage: user.profileImg_, status: user.status)
                self._profileHeaderViewModel.put(viewmodel)
            })
            .map { _ in }
    }
}