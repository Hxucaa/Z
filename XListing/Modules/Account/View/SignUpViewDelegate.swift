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
    func presentUIImagePickerController(imagePicker: UIImagePickerController)
    var dismissSignUpView: CompletionHandler? -> Void { get }
}