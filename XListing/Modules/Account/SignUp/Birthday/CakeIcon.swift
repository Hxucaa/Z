//
//  CakeIcon.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-10.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import XAssets

@IBDesignable
public final class CakeIcon : UIView {
    public override func drawRect(rect: CGRect) {
        AssetsKit.drawCakeIcon(scale: 1.0)
    }
}