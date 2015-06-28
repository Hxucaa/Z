//
// ProfileViewModel.swift
// XListing
//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public struct ProfileViewModel : IProfileViewModel {
    private let userService: IUserService
    
    public let nickname: MutableProperty<String> = MutableProperty("")
    
    public init(userService: IUserService) {
        self.userService = userService
        
        self.userService.currentLoggedInUser()
            |> start(
                next: { user in
                    if let nickname = user.nickname {
                        self.nickname.put(nickname)
                    }
                }
            )
    }
}
