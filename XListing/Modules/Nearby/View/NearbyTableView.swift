//
//  NearbyBusinessTableView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public class NearbyTableView : UITableView {
    public override func awakeFromNib() {
        super.awakeFromNib()
       // self.backgroundColor = UIColor.clearColor()
    }
    
    public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return point.y >= 0 && super.pointInside(point, withEvent: event)
    }
}