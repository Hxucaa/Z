//
//  File.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

extension UIColor {
    internal class func x_HUDBackgroundColor() -> UIColor {
        return UIColor(red: 51.0/255, green: 51.0/255, blue: 51.0/255, alpha: 0.8)
    }
    
    internal class func x_HUDForegroundColor() -> UIColor {
        return UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1)
    }
    
    internal class func x_PrimaryColor() -> UIColor {
        return UIColor(red: 22/255, green: 165/255, blue: 145/255, alpha: 1)
    }

    internal class func x_Transparent() -> UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
    }
    
    internal class func x_FeaturedCardBG() -> UIColor {
        return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    }
}