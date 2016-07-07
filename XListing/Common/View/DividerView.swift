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
        backgroundColor = UIColor(red: 213.0/255.0, green: 213.0/255.0, blue: 213.0/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, 1)
    }
}