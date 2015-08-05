//
//  LandingPageLogoView.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-29.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import XAssets

//@IBDesignable
public final class LandingPageLogoView: UIView {
    
    public override func drawRect(rect: CGRect) {
        var deviceWidth = UIScreen.mainScreen().bounds.size.width
        var scale = deviceWidth/CGFloat(LOGO_SCALE_BASE_FACTOR)
        self.bounds.size.width = rect.width * scale
        self.bounds.size.height = rect.height * scale
        AssetsKit.drawLandingIcon(scale: 0.5)
    }
}