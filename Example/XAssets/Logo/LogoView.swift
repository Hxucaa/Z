//
//  LogoView.swift
//  XAssets
//
//  Created by Lance Zhu on 2015-06-30.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import XAssets

@IBDesignable
final class LogoView : UIView {
    override func drawRect(rect: CGRect) {
        AssetsKit.drawLandingIcon(scale: 0.5)
    }
}