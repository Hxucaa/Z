//
//  SignUpViewDelegate.swift
//  XListing
//
//  Created by Lance on 2015-05-25.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol SignUpViewDelegate : class {
    func submitUpdate(#nickname: String, birthday: NSDate)
    func presentUIImagePickerController()
    func dismissViewController()
}