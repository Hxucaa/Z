//
// ProfileViewModel.swift
// XListing
//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public class ProfileViewModel : IProfileViewModel {
    private let userService: IUserService
    
    public var nickname: ConstantProperty<String>?
    
    public init(userService: IUserService) {
        self.userService = userService
        
//        if let currentUser = userService.currentUser() {
        nickname = ConstantProperty(userService.currentUser()!.nickname)
//        }
    }
    
    public func prepareData() {
        if let currentUser = userService.currentUser() {
            nickname = ConstantProperty(currentUser.nickname)
        }
    }
}
