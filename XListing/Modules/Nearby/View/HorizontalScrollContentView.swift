//
//  HorizontalScrollContentView.swift
//  XListing
//
//  Created by Bruce Li on 2015-04-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public class HorizontalScrollContentView: UIView {
    
    internal var pageWidth: CGFloat?
    private var kGutterWidth: CGFloat = 0
    
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        return hitView == self ? nil : hitView
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        var superSize = self.superview?.bounds.size
        var x = kGutterWidth * 3 / 2
        var subWidth = superSize?.width
        var subHeight = superSize?.height
        
        for subview in self.subviews as! [UITableView]{
            
            subview.frame = CGRectMake(x, 0, subWidth!, subHeight!)
            x += subWidth! + kGutterWidth
            
            var topInset = subHeight! - subview.rowHeight
            subview.contentInset =  UIEdgeInsets(top: topInset, left: subview.contentInset.left, bottom: subview.contentInset.bottom, right: subview.contentInset.right)
            
            subview.contentOffset = CGPointMake(0, -topInset)
            
            x += kGutterWidth/2
            self.frame = CGRectMake(0, 0, x, subHeight!)
            var scrollView = self.superview as! UIScrollView
            scrollView.contentSize = self.bounds.size
            
            pageWidth = subWidth! + kGutterWidth
            
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}