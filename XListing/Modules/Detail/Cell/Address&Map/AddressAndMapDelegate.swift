//
//  AddressAndMapDelegate.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public protocol AddressAndMapDelegate: class {
    
    func pushNavigationMapViewController<T: UIViewController>(viewController: T)
}