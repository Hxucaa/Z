//
//  SignUpViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit
import SwiftTask

public final class SignUpViewModel : NSObject {
    
    private let userService: IUserService
    
    public private(set) lazy var editProfileViewModel: EditProfileViewModel = EditProfileViewModel(userService: self.userService)
    
    public required init(userService: IUserService) {
        self.userService = userService
        
        super.init()
    }
}