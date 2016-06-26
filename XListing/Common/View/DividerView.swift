//
//  DividerView.swift
//  XListing
//
//  Created by Lance Zhu 2015-09-21.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit

public class DividerView : UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        userInteractionEnabled = false
        opaque = true
        backgroundColor = UIColor(hex: "D5D5D5")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, 1)
    }
}