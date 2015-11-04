//
//  ProfileTabInfoPanelView.swift
//  XListing
//
//  Created by Anson on 2015-10-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//


import Foundation
import UIKit
import ReactiveCocoa
import TZStackView
import Cartography
import TTTAttributedLabel
import XAssets
import Dollar

public final class ProfileTabInfoPanelView : UIView {
    
    // MARK: - UI Controls
    
    private lazy var businessNameAndFeaturedIconContainer: TZStackView = {
        let container = TZStackView(arrangedSubviews: [self.businessNameLabel, self.featuredIconImageView])
        
        container.distribution = TZStackViewDistribution.EqualSpacing
        container.axis = .Horizontal
        container.spacing = 5
        container.alignment = TZStackViewAlignment.Center
        container.opaque = true
        container.backgroundColor = .x_ProfileTableBG()
        
        return container
    }()
    
    private lazy var businessNameLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(12, 8, 80, 20))
        
        label.opaque = true
        label.backgroundColor = .x_ProfileTableBG()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.boldSystemFontOfSize(18)
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private lazy var featuredIconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(40, 10, 20, 20))
        
        imageView.opaque = true
        imageView.backgroundColor = .x_ProfileTableBG()
        
        return imageView
    }()
    
    private lazy var locationLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(12, 35, 60, 20))
        
        label.opaque = true
        label.backgroundColor = .x_ProfileTableBG()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(12)
        
        return label
    }()
    
    // MARK: - Properties
    private var viewmodel: ProfileTabInfoPanelViewModel!
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Setups
    
    private func setup() {
        opaque = true
        backgroundColor = .x_ProfileTableBG()
        clipsToBounds = true
        
        addSubview(businessNameAndFeaturedIconContainer)
        addSubview(locationLabel)
        
        constrain(featuredIconImageView) { view in
            view.height == 20
            view.width == 20
        }
        
        constrain([businessNameAndFeaturedIconContainer, locationLabel]) { views in
            
            // align the business name, location, price icon to leading
            align(leading: views[0], views[1])
            
            views[0].width <= views[0].superview!.width * 0.85
            views[0].leading == views[0].superview!.leadingMargin + 4
            views[0].top == views[0].superview!.top + 15
            
            views[1].top == views[0].bottom + 5
        }
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: ProfileTabInfoPanelViewModel) {
        self.viewmodel = viewmodel
        
        businessNameLabel.rac_text <~ viewmodel.businessName.producer
        
        locationLabel.rac_text <~ viewmodel.city.producer
    }
    
    // MARK: - Others
}
