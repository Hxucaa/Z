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
    private let router: IRouter
    public let user: MutableProperty<User> = MutableProperty(User())
    
    public let nickname: MutableProperty<String> = MutableProperty("")
    
    public init(router: IRouter, userService: IUserService) {
        self.router = router
        self.userService = userService
        
        self.userService.currentLoggedInUser()
            |> start(
                next: { user in
                    if let nickname: AnyObject = user.username {
                        self.nickname.put(nickname as! String)
                    }
                    self.user.put(user)
                }
            )
    }
    
    public func presentProfileEditModule() {
        router.presentProfileEdit(user.value, completion: nil)
    }
}
