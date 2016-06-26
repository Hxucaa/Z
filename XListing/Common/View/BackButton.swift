//
//  BackButton.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-06.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import UIKit

public final class BackButton: UIButton {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup () {
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: Fonts.FontAwesome, size: 17)!]
        let attributedString = NSAttributedString(string: Icons.Chevron.rawValue, attributes: attributes)
        setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
        titleLabel?.layer.masksToBounds = false
        titleLabel?.layer.shadowRadius = 3.0
        titleLabel?.layer.shadowOpacity = 0.5
        titleLabel?.layer.shadowOffset = CGSize.zero
        titleLabel?.layer.shadowColor = UIColor.grayColor().CGColor
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(40, 40)
    }
    

}
