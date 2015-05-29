//
//  HorizontalScrollView.swift
//  XListing
//
//  Created by Bruce Li on 2015-04-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class HorizontalScrollView: UIScrollView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, withEvent: event)
        return hitView == self ? nil : hitView
    }
    
}