//
//  WantToGoTableViewCell.swift
//  XListing
//
//  Created by William Qi on 2015-06-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import ReactiveCocoa

public final class WantToGoTableViewCell : UITableViewCell, ReactiveTableCellView {
    
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
    }
    
    public func bindViewModel(viewmodel: ReactiveTableCellViewModel) {

    }

    
}