//
//  AgeGroupLabel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Dollar
import TTTAttributedLabel

public final class AgeGroupLabel : TTTAttributedLabel {
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.whiteColor()
        opaque = true
        textAlignment = NSTextAlignment.Center
        font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        textInsets = UIEdgeInsets(top: 1, left: 7, bottom: 1, right: 7)
        // TODO: Fix the performance issue caused by cornerRadius
        layer.masksToBounds = true
        layer.cornerRadius = 10
        
        // TODO: May not be correct. Require further investigation.
        layer.shouldRasterize = true
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}