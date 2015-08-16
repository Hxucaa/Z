//
//  StatusBarBackgroundView.swift
//  XListing
//
//  Created by Lance on 2015-08-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public final class StatusBarBackgroundView : UIView {
    public init() {
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 20))
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        backgroundColor = UIColor.x_PrimaryColor()
    }
}