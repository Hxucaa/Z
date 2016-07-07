//
//  AgeGroupLabel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-06.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit
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
        layer.cornerRadius = 9
        
        // TODO: May not be correct. Require further investigation.
        layer.shouldRasterize = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func bindToData(ageGroup: AgeGroup, gender: Gender) {
        text = ageGroup.description
        switch gender {
        case .Male:
            backgroundColor = .blueColor()
        case .Female:
            backgroundColor = .redColor()
        }
    }
}