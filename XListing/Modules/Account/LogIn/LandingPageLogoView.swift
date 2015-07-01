//
//  LandingPageLogoView.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-29.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import XAssets

@IBDesignable
public final class LandingPageLogoView: UIView {
    
    public override func drawRect(rect: CGRect) {
        AssetsKit.drawLandingIcon(scale:0.5)
    }
}