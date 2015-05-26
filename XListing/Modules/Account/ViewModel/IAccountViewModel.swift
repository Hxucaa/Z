//
//  ILogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import SwiftTask

public protocol IAccountViewModel {
    func updateProfile(nickname: String, birthday: NSDate) -> Task<Int, Bool, NSError>
    func updateProfilePicture(image: UIImage)
}