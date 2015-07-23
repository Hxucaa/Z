//
//  EditInfoViewDelegate.swift
//  XListing
//
//  Created by Lance on 2015-05-25.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public protocol EditInfoViewDelegate : class {
    func presentUIImagePickerController(imagePicker: UIImagePickerController)
    func dismissUIImagePickerController(handler: CompletionHandler?)
    func editProfileViewFinished()
}