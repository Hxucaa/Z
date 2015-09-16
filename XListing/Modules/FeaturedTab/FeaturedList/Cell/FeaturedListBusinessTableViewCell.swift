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
import TZStackView
import Cartography
import TTTAttributedLabel
import XAssets
import Dollar

public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    // MARK: - UI Controls
    
    private lazy var backgroundContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.clipsToBounds = true
        view.addSubview(self.mainStackView)
        
        constrain(self.mainStackView) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin
            view.trailing == view.superview!.trailingMargin
            view.bottom == view.superview!.bottom - 5
        }
        
        return view
    }()

    /**
    *   MARK: Main Stack View
    */
    private lazy var mainStackView: TZStackView = {
        let container = TZStackView(arrangedSubviews: [self.topSectionContainer, self.dividerView, self.statsStackView, self.participationView])
        container.distribution = TZStackViewDistribution.FillProportionally
        container.axis = .Vertical
        container.spacing = 5
        container.alignment = TZStackViewAlignment.Leading
        
        constrain(self.topSectionContainer) { view in
            view.width == view.superview!.width
        }
        
        constrain(self.dividerView) { divider in
            divider.width == divider.superview!.width
        }
        
        constrain(self.statsStackView) { view in
            view.height == view.superview!.height * 0.10
        }
        
        constrain(self.participationView) { view in
            view.height == view.superview!.height * 0.20
            view.width == view.superview!.width
        }
        
        return container
    }()
    
    /**
    *   MARK: Top Section
    */
    
    private lazy var topSectionContainer: UIView = {
        let view = UIView()
        
        view.opaque = true
        view.backgroundColor = UIColor.whiteColor()
        view.clipsToBounds = true
        
        view.addSubview(self.businessImageView)
        view.addSubview(self.infoPanelView)
        
        constrain(self.businessImageView, self.infoPanelView) { image, info in
            image.leading == image.superview!.leading
            image.top == image.superview!.top
            image.width == image.superview!.width * 0.60
            image.bottom == image.superview!.bottom
            
            (info.leading == image.trailing).identifier = "infoPanelView leading"
            (info.top == info.superview!.top).identifier = "infoPanelView top"
            (info.trailing == info.superview!.trailing).identifier = "infoPanelView trailing"
            (info.bottom == info.superview!.bottom).identifier = "infoPanelView bottom"
            
        }
        
        self.businessImageView.setContentCompressionResistancePriority(751, forAxis: .Horizontal)
        self.infoPanelView.setContentCompressionResistancePriority(749, forAxis: .Horizontal)
        
        return view
    }()
    
    private lazy var businessImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        
        
        return imageView
    }()
    
    private lazy var infoPanelView: FeaturedListBusinessCell_InfoPanelView = {
        let view = FeaturedListBusinessCell_InfoPanelView()
        
        return view
    }()
    
    /**
    *   Divider
    */
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        
        view.userInteractionEnabled = false
        view.opaque = true
        view.backgroundColor = UIColor(hex: "D5D5D5")
        
        constrain(view) { view in
            view.height == 1
        }
        
        return view
    }()
    
    /**
    *   MARK: Stats Section
    */
    private lazy var statsStackView: FeaturedListBusinessCell_StatsStackView = {
        let view = FeaturedListBusinessCell_StatsStackView()
        
        return view
    }()
        
    /**
    *   MARK: Participation section
    */
    private lazy var participationView: FeaturedListBusinessCell_ParticipationView = {
        let view = FeaturedListBusinessCell_ParticipationView()
        
        return view
    }()
    
    // MARK: - Properties
    private var viewmodel: IFeaturedBusinessViewModel! {
        didSet {
            infoPanelView.bindToViewModel(viewmodel.infoPanelViewModel)
            participationView.bindToViewModel(viewmodel.pariticipationViewModel)
            statsStackView.bindToViewModel(viewmodel.statsViewModel)
        }
    }

    // MARK: - Initializers
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        opaque = true
        backgroundColor = .grayColor()
        
        addSubview(backgroundContainer)
        
        constrain(backgroundContainer) { view in
            view.leading == view.superview!.leading + 5
            view.top == view.superview!.topMargin
            view.trailing == view.superview!.trailing - 5
            view.bottom == view.superview!.bottom
        }
        
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setups
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        participationView.initiateReuse()
    }
    
    // MARK: Bindings
    public func bindViewModel(viewmodel: IFeaturedBusinessViewModel) {
        self.viewmodel = viewmodel

        self.viewmodel.getCoverImage()
            |> start()

        self.viewmodel.coverImage.producer
            |> takeUntilPrepareForReuse(self)
            |> ignoreNil
            |> start (next: { [weak self] image in
                self?.businessImageView.image = image
                
            })

    }
}