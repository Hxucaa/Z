//
//  PriceLabel.swift
//  
//
//  Created by Connor Wang on 8/16/15.
//
//

import UIKit
import XAssets

@IBDesignable final class PriceLabel : UIView {
    override func drawRect(rect: CGRect) {
        AssetsKit.drawPriceTagBackground(scale: 0.2, pricetag: "人均100")
    }
}