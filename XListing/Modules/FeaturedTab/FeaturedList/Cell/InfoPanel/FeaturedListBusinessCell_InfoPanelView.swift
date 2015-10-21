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

private let etaPriceIconSize = round(UIScreen.mainScreen().bounds.width * 0.032)

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
        let label = TTTAttributedLabel(frame: CGRectMake(12, 8, 80, 20))
        label.opaque = true
        label.backgroundColor = .x_FeaturedCardBG()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.boldSystemFontOfSize(15.5)
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private lazy var featuredIconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(40, 10, 20, 20))
        imageView.opaque = true
        imageView.backgroundColor = .x_FeaturedCardBG()
        
        return imageView
    }()
    
    private lazy var locationLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(12, 35, 60, 20))
        label.opaque = true
        label.backgroundColor = .x_FeaturedCardBG()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(12)
        
        return label
    }()
    
    /**
    *   MARK: Price and ETA
    */
    
    private func makeIconImageView(frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.opaque = true
        imageView.backgroundColor = .x_FeaturedCardBG()
        
        return imageView
    }
    
    private func makeCaptionLabel(frame: CGRect) -> TTTAttributedLabel {
        let label = TTTAttributedLabel(frame: frame)
        label.opaque = true
        label.backgroundColor = .x_FeaturedCardBG()
        label.textColor = UIColor(hex: "828282")
        label.font = UIFont.systemFontOfSize(10)
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        
        return label
    }
    
    private lazy var priceIconImageView: UIImageView = {
        let imageView = self.makeIconImageView(CGRectMake(10, 110, 12, 12))
        
        imageView.rac_image <~ AssetFactory.getImage(Asset.PriceIcon(size: imageView.frame.size, backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            |> take(1)
            |> map { Optional<UIImage>($0) }
        
        return imageView
        
    }()
    
    private lazy var priceLabel: TTTAttributedLabel = {
        let label = self.makeCaptionLabel(CGRectMake(30, 110, 40, 20))
        
        return label
    }()
    
    private lazy var etaIconImageView: UIImageView = {
        let imageView = self.makeIconImageView(CGRectMake(60, 110, 12, 12))
        
        // Adding ETA icon
        imageView.rac_image <~ AssetFactory.getImage(Asset.CarIcon(size: imageView.frame.size, backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            |> take(1)
            |> map { Optional<UIImage>($0) }
        
        return imageView
        
    }()
    
    private lazy var etaLabel: TTTAttributedLabel = {
        let label = self.makeCaptionLabel(CGRectMake(80, 110, 40, 20))
        
        return label
    }()
    
    // MARK: - Properties
    private var viewmodel: IFeaturedListBusinessCell_InfoPanelViewModel!
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setNeedsUpdateConstraints()
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
            view.height == etaPriceIconSize
            view.width == etaPriceIconSize
        }
        
        constrain(priceIconImageView) { view in
            view.height == etaPriceIconSize
            view.width == etaPriceIconSize
        }
        
        constrain([businessNameAndFeaturedIconContainer, locationLabel, priceIconImageView, priceLabel, etaIconImageView, etaLabel]) { views in
            
            // align the business name, location, price icon to leading
            align(leading: views[0], views[1])
            
            views[0].width <= views[0].superview!.width * 0.85
            views[0].leading == views[0].superview!.leadingMargin + 4
            views[0].top == views[0].superview!.top + 8
            
            views[1].top == views[0].bottom + 5
            
            align(centerY: views[2], views[3], views[4], views[5])
            
            views[2].bottom == views[2].superview!.bottom - 24
            views[2].leading == views[2].superview!.leading + 20
            views[2].trailing == views[3].leading - 3
            views[3].trailing == views[4].leading - 3
            views[4].trailing == views[5].leading - 3
            views[5].trailing == views[5].superview!.trailingMargin - 8
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