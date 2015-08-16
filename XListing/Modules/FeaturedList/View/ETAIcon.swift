//
//  ETAIcon.swift
//  XListing
//
//  Created by Connor Wang on 8/16/15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import XAssets

@IBDesignable final class ETAIcon : UIView {
    override func drawRect(rect: CGRect) {
        AssetsKit.drawCarIcon(scale: 0.5)
    }
}