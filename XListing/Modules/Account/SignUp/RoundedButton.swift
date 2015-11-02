//
//  RoundedButton.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-10.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public class RoundedButton : UIButton {
    public convenience init() {
        self.init(frame: CGRect(x: 168.0, y: 8.0, width: 265.0, height: 60.0))
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        opaque = false
        contentMode = UIViewContentMode.ScaleToFill
        contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
        titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "STHeitiSC-Medium", size: 19.0), size: 19.0)
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}