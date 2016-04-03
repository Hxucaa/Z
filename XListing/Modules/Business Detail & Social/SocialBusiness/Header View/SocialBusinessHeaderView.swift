//
//  SocialBusinessHeaderView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import TZStackView
import Cartography
import TTTAttributedLabel
import RxSwift
import RxCocoa


private let CoverImageWidth = round(UIScreen.mainScreen().bounds.width * 0.20)
private let CoverImageSize = CGSizeMake(CoverImageWidth, CoverImageWidth)

final class SocialBusinessHeaderView : UIView {
    
    // MARK: - UI Controls
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: self.frame)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = imageView.frame
        
        imageView.addSubview(effectView)
        
        constrain(effectView) { view in
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
        }
        
        return imageView
    }()
    
    /// Wrap everything in the main stack and have them distributed vertically.
    private lazy var mainContainer: TZStackView = {
        
        let container = TZStackView(arrangedSubviews: [self.coverImageView, self.businessNameLabel, self.cuisineAndPriceContainer, self.locationAndDistanceContainer])
        container.distribution = TZStackViewDistribution.EqualSpacing
        container.axis = .Vertical
        container.spacing = 8
        container.alignment = .Center
        
        return container
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: CGPointMake(0, 0), size: CoverImageSize))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        return imageView
    }()
    
    private lazy var businessNameLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 70, 40))
        label.opaque = false
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(37)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.whiteColor()
        
        return label
    }()
    
    private lazy var cuisineLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 50, 22))
        label.opaque = false
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.whiteColor()
        
        return label
        
    }()
    
    private lazy var priceLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 50, 22))
        label.opaque = false
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.whiteColor()
        
        return label
        
        }()
    
    /// Wrap location, divider, and distance in a stack
    private lazy var cuisineAndPriceContainer: TZStackView = {
        let container = TZStackView(arrangedSubviews: [self.cuisineLabel, self.priceLabel])
        container.distribution = TZStackViewDistribution.EqualSpacing
        container.axis = .Horizontal
        container.spacing = 10
        container.alignment = .Center
        
        return container
        }()
    
    /// Wrap location, divider, and distance in a stack
    private lazy var locationAndDistanceContainer: TZStackView = {
        let container = TZStackView(arrangedSubviews: [self.locationLabel, self.dividerView, self.distanceLabel])
        container.distribution = TZStackViewDistribution.EqualSpacing
        container.axis = .Horizontal
        container.spacing = 10
        container.alignment = .Center
        
        return container
    }()
    
    private lazy var locationLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 50, 22))
        label.opaque = false
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.whiteColor()
        
        return label
        
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, 1, 22))
        view.opaque = true
        view.backgroundColor = UIColor.whiteColor()
        
        return view
    }()
    
    private lazy var distanceLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 50, 22))
        label.opaque = false
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.whiteColor()
        
        return label
        
    }()
    
    // MARK: - Proxies
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        cuisineLabel.text = "川菜"
        priceLabel.text = "$$"

        addSubview(backgroundImageView)
        backgroundImageView.addSubview(mainContainer)
        
        coverImageView.setContentCompressionResistancePriority(700, forAxis: .Vertical)

        constrain(backgroundImageView) { view in
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
        }

        constrain(dividerView, locationLabel) { divider, location in
            divider.width == 1
            divider.height == location.height * 0.80
        }
        
        constrain(mainContainer) { view in
            view.centerX == view.superview!.centerX
            
            let gap = round(self.backgroundImageView.frame.height * 0.07)
            view.top == view.superview!.topMargin + gap
            view.bottom == view.superview!.bottomMargin
            view.leading == view.superview!.leadingMargin
            view.trailing == view.superview!.trailingMargin
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    override func intrinsicContentSize() -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, screenWidth * 0.61)
    }
    
    // MARK: - Bindings
    
    func bindToCellData(businessName: String, location: String, eta: Driver<String>, imageURL: NSURL?) {
        
        businessNameLabel.text = businessName
        locationLabel.text = location
        eta.drive(distanceLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        coverImageView.sd_setImageWithURL(imageURL)
        // FIXME: make image round
//            $0.maskWithRoundedRect(CoverImageSize, cornerRadius: max(CoverImageSize.width, CoverImageSize.height) / 2, borderWidth: 2, opaque: false)
        
        backgroundImageView.sd_setImageWithURL(imageURL)
        
    }
}
