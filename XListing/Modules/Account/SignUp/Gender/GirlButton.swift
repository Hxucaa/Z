//
//  GirlButton.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-10.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import XAssets

public final class GirlButton : UIButton {
    public override func drawRect(rect: CGRect) {
        AssetsKit.drawFemaleIcon()
    }
}
