//
//  DetailBizInfoCellDelegate.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public protocol DetailBizInfoCellDelegate: class {
    
    func participate<T: UIViewController>(viewController: T)
}
