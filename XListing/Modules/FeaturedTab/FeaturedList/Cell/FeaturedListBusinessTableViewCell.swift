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

private let BusinessImageViewWidthToTopSectionWidthRatio = 0.60
private let ParticipationViewHeightToMainStackViewHeightRatio = 0.20

public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    // MARK: - UI Controls
    
    private lazy var backgroundContainer: UIView = {
        let view = UIView(frame: CGRectMake(8, 8, self.estimatedFrame.width, self.estimatedFrame.height - 5))
        view.backgroundColor = UIColor.x_FeaturedCardBG()
        view.clipsToBounds = true
        
        return view
    }()

    /**
    *   MARK: Main Stack View
    */
    private lazy var mainStackView: TZStackView = {
        let container = TZStackView(arrangedSubviews: [self.topSectionContainer, self.dividerView, self.participationView])
        container.distribution = TZStackViewDistribution.EqualSpacing
        container.axis = .Vertical
        container.spacing = 9
        container.alignment = TZStackViewAlignment.Leading
        container.frame = CGRectMake(0, 0, self.estimatedFrame.width, self.estimatedFrame.height - 5)
        
        return container
    }()
    
    /**
    *   MARK: Top Section
    */
    
    private lazy var topSectionContainer: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, self.estimatedFrame.width, self.topSectionHeight))
        
        view.opaque = true
        view.backgroundColor = UIColor.x_FeaturedCardBG()
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var businessImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(0, 0, round(self.estimatedFrame.width * CGFloat(BusinessImageViewWidthToTopSectionWidthRatio)), self.topSectionHeight))
        imageView.backgroundColor = UIColor.x_FeaturedCardBG()
        imageView.image = UIImage(named: ImageAssets.businessplaceholder)
        
        
        return imageView
    }()
    
    private lazy var infoPanelView: FeaturedListBusinessCell_InfoPanelView = {
        let view = FeaturedListBusinessCell_InfoPanelView(frame: CGRectMake(round(self.estimatedFrame.width * CGFloat(BusinessImageViewWidthToTopSectionWidthRatio)), 0, round(self.estimatedFrame.width * 0.30), self.topSectionHeight))
        
        return view
    }()
    
    /**
    *   Divider
    */
    
    private lazy var dividerView: DividerView = {
        let view = DividerView(frame: CGRectMake(0, round(self.estimatedFrame.height * 0.65), self.estimatedFrame.width, 1))
        
        view.userInteractionEnabled = false
        view.opaque = true
        view.backgroundColor = UIColor(hex: "D5D5D5")
        
        return view
    }()
        
    /**
    *   MARK: Participation section
    */
    private lazy var participationView: FeaturedListBusinessCell_ParticipationView = {
        let view = FeaturedListBusinessCell_ParticipationView(frame: CGRectMake(0, round(self.estimatedFrame.height * 0.75), self.estimatedFrame.width, round(self.estimatedFrame.height * CGFloat(ParticipationViewHeightToMainStackViewHeightRatio))))
        
        return view
    }()
    
    // MARK: - Properties
    private let estimatedFrame: CGRect
    private let topSectionHeight: CGFloat
    private var didSetupInitialConstraints = false
    private var viewmodel: IFeaturedBusinessViewModel! {
        didSet {
            infoPanelView.bindToViewModel(viewmodel.infoPanelViewModel)
            participationView.bindToViewModel(viewmodel.pariticipationViewModel)
        }
    }

    // MARK: - Initializers
    public init(estimatedFrame: CGRect, style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.estimatedFrame = estimatedFrame
        topSectionHeight = round(self.estimatedFrame.height * 0.60)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = UITableViewCellSelectionStyle.None
        opaque = true
        backgroundColor = UIColor.x_FeaturedTableBG()
        
        /**
        *   background container
        */
        contentView.addSubview(backgroundContainer)
        constrain(backgroundContainer) { view in
            view.leading == view.superview!.leading + 8
            view.top == view.superview!.top + 6
            view.trailing == view.superview!.trailing - 8
            view.bottom == view.superview!.bottom
        }
        
        /**
        *   main StackView
        */
        backgroundContainer.addSubview(mainStackView)
        constrain(mainStackView) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom - 5
        }
        
        /**
        *   topSection Container
        */
        constrain(topSectionContainer) { view in
            view.width == view.superview!.width
        }
        
        /**
        *   businessImageView & infoPanelView
        */
        topSectionContainer.addSubview(businessImageView)
        topSectionContainer.addSubview(infoPanelView)
        
        businessImageView.setContentCompressionResistancePriority(751, forAxis: .Horizontal)
        infoPanelView.setContentCompressionResistancePriority(749, forAxis: .Horizontal)
        
        constrain(businessImageView, infoPanelView) { image, info in
            image.leading == image.superview!.leading
            image.top == image.superview!.top
            image.width == image.superview!.width * 0.58
            image.bottom == image.superview!.bottom
            
            (info.leading == image.trailing).identifier = "infoPanelView leading"
            (info.top == info.superview!.top).identifier = "infoPanelView top"
            (info.trailing == info.superview!.trailing).identifier = "infoPanelView trailing"
            (info.bottom == info.superview!.bottom).identifier = "infoPanelView bottom"
            
        }
        
        /**
        *   dividier
        */
        constrain(dividerView) { divider in
            divider.width == divider.superview!.width
        }
        dividerView.setContentCompressionResistancePriority(751, forAxis: .Vertical)
        
        /**
        *   particiation view
        */
        constrain(participationView) { view in
            view.height == view.superview!.height * 0.27
            view.width == view.superview!.width
        }
        
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setups

    public override func prepareForReuse() {
        participationView.initiateReuse()
        
        super.prepareForReuse()
        
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