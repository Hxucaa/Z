//
//  FeaturedListBusinessTableViewCell.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-20.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography
import React

public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    // MARK: - UI Controls
    private let featuredListTableCell: RCTRootView
    
    // MARK: - Properties
    private var viewmodel: IFeaturedBusinessViewModel!

    // MARK: - Initializers
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        featuredListTableCell = RCTRootView(bridge: appDelegate.rnBridge, moduleName: "FeaturedListTableCell", initialProperties: nil)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = UITableViewCellSelectionStyle.None
        opaque = true
        backgroundColor = UIColor.x_FeaturedTableBG()
    
        
        contentView.addSubview(featuredListTableCell)
        
        constrain(featuredListTableCell) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setups

//    public override func prepareForReuse() {
//        featuredListTableCell.appProperties = [
//            
//        ]
//        
//        super.prepareForReuse()
//        
//    }
    
    // MARK: Bindings
    public func bindViewModel(viewmodel: IFeaturedBusinessViewModel) {
        self.viewmodel = viewmodel

//
        self.viewmodel.calculateEta()
            .start()
        
        self.viewmodel.props
            .takeUntilPrepareForReuse(self)
            .startWithNext { [weak self] dict in
                self?.featuredListTableCell.appProperties = dict
            }
    }
}