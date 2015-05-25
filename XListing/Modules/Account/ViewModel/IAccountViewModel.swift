//
//  ILogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public protocol IAccountViewModel {
    func updateBirthday(birthday: NSDate)
    func getDisplayName() -> String
    func updateDisplayName(displayName: String)
    func updateProfilePicture(image: UIImage)
}