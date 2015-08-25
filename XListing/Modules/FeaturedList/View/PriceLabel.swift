//
//  PriceLabel.swift
//  
//
//  Created by Connor Wang on 8/16/15.
//
//

import UIKit
import XAssets

@IBDesignable public final class PriceLabel : UIView {
    var price = 100
    var text = "人均100"
    
    override public func drawRect(rect: CGRect) {
        AssetsKit.drawPriceTagBackground(scale: 0.2)
    }
    
    public func setPriceLabel(price: Int){
        self.price = price
        self.text = "人均\(price)"
    }
}