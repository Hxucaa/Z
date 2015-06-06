//
//  SignUpViewDelegate.swift
//  XListing
//
//  Created by Lance on 2015-05-25.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public protocol SignUpViewDelegate : class {
    func submitUpdate(#nickname: String, birthday: NSDate, profileImage: UIImage?)
    func presentUIImagePickerController(imagePicker: UIImagePickerController)
    func dismissViewController()
    var ageLimit: AgeLimit { get }
}