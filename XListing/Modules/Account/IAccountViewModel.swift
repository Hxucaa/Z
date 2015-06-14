//
//  ILogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import ReactKit
import SwiftTask

public protocol IAccountViewModel {
    var editProfileViewModel: EditProfileViewModel { get }
    init(userService: IUserService, router: IRouter)
    func pushFeaturedModule()
}