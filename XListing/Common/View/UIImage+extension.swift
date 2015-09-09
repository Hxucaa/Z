//
//  UIImage+extension.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /**
    Draw an UIImage with rounded corner via CGGraphics. Note that if the cornerRadius is bigger than the radius of the image, it will be a circle.
    
    :param: sizeToFit       Size of the image to draw on.
    :param: cornerRadius    Raidus of corner.
    :param: borderWidth     Default to 0.
    :param: borderColor     Default to white.
    :param: backgroundColor Background color. If you set `opaque` to true, you should provide a background color otherwise it will be black.
    :param: opaque          By default, set to true for performance reason.
    :param: scale           By default, set to `UIScreen.mainScreen().scale`.
    
    :returns: The drawn UIImage.
    */
    public func maskWithRoundedRect(sizeToFit: CGSize, cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.whiteColor(), backgroundColor: UIColor? = nil, opaque: Bool = true, scale: CGFloat = UIScreen.mainScreen().scale) -> UIImage {
        // size to draw
        let rect = CGRect(origin: CGPointZero, size: sizeToFit)
        
        UIGraphicsBeginImageContextWithOptions(sizeToFit, opaque ?? true, scale ?? UIScreen.mainScreen().scale)
        
        // fill the background color first if available
        if let backgroundColor = backgroundColor {
            backgroundColor.set()
            UIRectFill(rect)
        }
        
        // drawing path
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())
        
        drawInRect(rect)
        
        // draw border
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), borderColor.CGColor)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), borderWidth)
        path.lineWidth = borderWidth * 2
        path.stroke()
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return output
    }
}