//
//  Icons.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-28.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public enum Icons : String {
    case User = "\u{f007}"
    case Gender = "\u{f228}"
    case Birthday = "\u{f06b}"
    case Status = "\u{f0a1}"
    case Email = "\u{f003}"
    case Phone = "\u{f095}"
    case X = "\u{f00d}"   // swiftlint:disable:this variable_name_min_length
    case Chevron = "\u{f053}"
    case Location = "\u{f124}"
    case Female = "\u{f221}"
    case Male = "\u{f222}"
    
    public func getUIImage(iconSize: CGFloat, iconColour: UIColor = UIColor.blackColor(), imageSize: CGSize) -> UIImage? {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Left
        style.baseWritingDirection = NSWritingDirection.LeftToRight
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        guard let font = UIFont(name: Fonts.FontAwesome, size: iconSize) else {
            return nil
        }
        
        let attString = NSMutableAttributedString(string: self.rawValue, attributes: [NSFontAttributeName: font])
        attString.addAttributes([NSForegroundColorAttributeName: iconColour, NSParagraphStyleAttributeName: style], range: NSMakeRange(0, attString.length))
        
        // get the target bounding rect in order to center the icon within the UIImage:
        let ctx = NSStringDrawingContext()
        let boundingRect = attString.boundingRectWithSize(CGSizeMake(iconSize, iconSize), options: NSStringDrawingOptions.UsesDeviceMetrics, context: ctx)
        
        attString.drawInRect(CGRectMake((imageSize.width / 2.0) - boundingRect.size.width/2.0, (imageSize.height / 2.0) - boundingRect.size.height / 2.0, imageSize.width, imageSize.height))
        
        var iconImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if iconImage.respondsToSelector(#selector(UIImage.imageWithRenderingMode(_:))) {
            iconImage = iconImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
        
        return iconImage
    }
}
