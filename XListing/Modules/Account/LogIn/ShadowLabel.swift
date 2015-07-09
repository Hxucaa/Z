//
//  ShadowLabel.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

@IBDesignable
public final class ShadowLabel: UILabel {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func drawTextInRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorValues : Array<CGFloat> = [0, 0, 0, 0.4]
        var shadowColor = CGColorCreate(colorSpace, colorValues);
        var shadowOffset = CGSizeMake(1, -3);
        CGContextSetShadowWithColor (context, shadowOffset, 4, shadowColor)
        super.drawTextInRect(rect)

        //CGContextRestoreGState(context);
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = false
    }
}
