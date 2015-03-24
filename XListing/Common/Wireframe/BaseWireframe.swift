//
//  BaseWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

let storyboardName = "Main"

class BaseWireframe {
    
    /**
    Get storyboard.
    
    :returns: The UIStoryboard
    */
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
        return storyboard
    }
}