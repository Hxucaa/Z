//
//  DetailPhoneWebCellDelegate.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public protocol DetailPhoneWebCellDelegate: class {
    func presentWebView<T: UIViewController>(viewController: T)
}