//
//  Device.swift
//  XListing
//
//  Created by Hong Zhu on 2016-02-05.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public enum DeviceWidthTypeInPortrait : CGFloat {
    case Small = 375
    case Plus = 414
    case iPad = 768
}

public extension UIScreen {
    var deviceWidthTypeInPortrait: DeviceWidthTypeInPortrait? {
        return DeviceWidthTypeInPortrait(rawValue: self.bounds.size.width)
    }
}
