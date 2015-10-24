//
//  FeaturedListBusinessCell_InfoPanelView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-15.
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


public final class FeaturedListBusinessCell_InfoPanelView : UIView {
    
    // MARK: - UI Controls
    
    /**
    *   店铺名称 和 推荐图标
    */
    
    private lazy var businessNameAndFeaturedIconContainer: TZStackView = {
        let container = TZStackView(arrangedSubviews: [self.businessNameLabel, self.featuredIconImageView])
        container.distribution = TZStackViewDistribution.EqualSpacing
        container.axis = .Horizontal
        container.spacing = 5
        container.alignment = TZStackViewAlignment.Center
        
        return container
        
    }()
    
    private lazy var businessNameLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 40, 20))
        label.opaque = true
        label.backgroundColor = .x_FeaturedCardBG()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(19)
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private lazy var featuredIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.opaque = true
        imageView.backgroundColor = .x_FeaturedCardBG()
        
        return imageView
    }()
    
    private lazy var locationLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 40, 20))
        label.opaque = true
        label.backgroundColor = .x_FeaturedCardBG()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(12)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    /**
    *   MARK: Price and ETA
    */
    
    private func makeIconImageView() -> UIImageView {
        let imageView = UIImageView(frame: CGRectMake(0, 0, 12, 12))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.opaque = true
        imageView.backgroundColor = .x_FeaturedCardBG()
        imageView.layer.rasterizationScale = UIScreen.mainScreen().scale
        imageView.layer.shouldRasterize = true
        
        return imageView
    }
    
    private func makeCaptionLabel() -> TTTAttributedLabel {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 40, 20))
        label.opaque = true
        label.backgroundColor = .x_FeaturedCardBG()
        label.textColor = UIColor(hex: "828282")
        label.font = UIFont.systemFontOfSize(12)
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        
        return label
    }
    
    private lazy var priceIconImageView: UIImageView = {
        let imageView = self.makeIconImageView()
        
        imageView.rac_image <~ AssetFactory.getImage(Asset.PriceIcon(size: imageView.frame.size, backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            |> take(1)
            |> map { Optional<UIImage>($0) }
        
        return imageView
        
    }()
    
    private lazy var priceLabel: TTTAttributedLabel = {
        let label = self.makeCaptionLabel()
        
        return label
    }()
    
    private lazy var etaIconImageView: UIImageView = {
        let imageView = self.makeIconImageView()
        
        // Adding ETA icon
        imageView.rac_image <~ AssetFactory.getImage(Asset.CarIcon(size: imageView.frame.size, backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            |> take(1)
            |> map { Optional<UIImage>($0) }
        
        return imageView
        
    }()
    
    private lazy var etaLabel: TTTAttributedLabel = {
        let label = self.makeCaptionLabel()
        
        return label
    }()
    
    // MARK: - Properties
    private var viewmodel: IFeaturedListBusinessCell_InfoPanelViewModel!
    
    // MARK: - Initializers
    public init() {
        super.init(frame: CGRectMake(0, 0, 0, 0))
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setup() {
        
        opaque = true
        backgroundColor = .x_FeaturedCardBG()
        clipsToBounds = true
        
        addSubview(businessNameAndFeaturedIconContainer)
        addSubview(locationLabel)
        addSubview(priceIconImageView)
        addSubview(priceLabel)
        addSubview(etaIconImageView)
        addSubview(etaLabel)
        
        constrain(featuredIconImageView) { view in
            view.height == 20
            view.width == 20
        }
        
        constrain(etaIconImageView) { view in
            view.height == 12
            view.width == 12
        }
        
        constrain(priceIconImageView) { view in
            view.height == 12
            view.width == 12
        }
        
        constrain([businessNameAndFeaturedIconContainer, locationLabel, priceIconImageView, priceLabel, etaIconImageView, etaLabel]) { views in
            
            // align the business name, location, price icon to leading
            align(leading: views[0], views[1], views[2])
            
            views[0].width <= views[0].superview!.width * 0.85
            views[0].leading == views[0].superview!.leadingMargin
            views[0].top == views[0].superview!.top + 5
            
            views[1].top == views[0].bottom + 5
            
            align(centerY: views[2], views[3], views[4], views[5])
            
            views[2].bottom == views[2].superview!.bottom - 5
            views[2].trailing == views[3].leading - 3
            
            views[4].trailing == views[5].leading - 3
            views[5].trailing == views[5].superview!.trailingMargin - 5
        }
    }

    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IFeaturedListBusinessCell_InfoPanelViewModel) {
        self.viewmodel = viewmodel
        
        businessNameLabel.rac_text <~ viewmodel.businessName.producer
        
        locationLabel.rac_text <~ viewmodel.city.producer
        
        viewmodel.price.producer
            |> ignoreNil
            |> start(next: { [weak self] price in
                self?.priceLabel.text = "$ \(price)"
            })
        
        etaLabel.rac_text <~ viewmodel.eta.producer
            |> ignoreNil
    }
    
    // MARK: - Others
    
}