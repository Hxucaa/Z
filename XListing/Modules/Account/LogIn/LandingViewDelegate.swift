//
//  LandingViewDelegate.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-20.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public protocol LandingViewDelegate : class {
    func switchToLoginView()
    func switchToSignUpView()
}