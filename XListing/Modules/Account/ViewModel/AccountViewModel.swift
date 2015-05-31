//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public final class AccountViewModel : IAccountViewModel {
    
    private let userService: IUserService
    
    public required init(userService: IUserService) {
        self.userService = userService
    }
    
    public func updateProfile(nickname: String, birthday: NSDate, profileImage: UIImage?) -> Task<Int, Bool, NSError> {
        let currentUser = userService.currentUser()!
        currentUser.birthday = birthday
        currentUser.nickname = nickname
        let imageData = UIImagePNGRepresentation(profileImage)
        return userService.save(currentUser)
    }
}














