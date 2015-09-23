//
//  SocialBusinessHeaderView.swift
//  XListing
//
//  Created by Anson on 2015-09-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import TZStackView
import Cartography
import TTTAttributedLabel
import ReactiveCocoa

private let CoverImageSize = CGSizeMake(110, 110)

public final class SocialBusinessHeaderView : UIView {
    
    // MARK: - UI Controls
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: self.frame)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
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
        
        let container = TZStackView(arrangedSubviews: [self.coverImageView, self.businessNameLabel, self.locationAndDistanceContainer])
        container.distribution = TZStackViewDistribution.EqualSpacing
        container.axis = .Vertical
        container.spacing = 8
        container.alignment = .Center
        
        return container
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: CGPointMake(0, 0), size: CoverImageSize))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
//        constrain(imageView) { view in
//            view.width == CoverImageSize.width
//            view.height == CoverImageSize.height
//        }
        
        imageView.setContentCompressionResistancePriority(700, forAxis: .Vertical)
        
        return imageView
    }()
    
    private lazy var businessNameLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 70, 40))
        label.opaque = false
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(24)
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
    private var viewmodel: SocialBusinessHeaderViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)

        cuisineLabel.text = "川菜"

        addSubview(backgroundImageView)
        backgroundImageView.addSubview(mainContainer)

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
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    public override func intrinsicContentSize() -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, screenWidth * 0.61)
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: SocialBusinessHeaderViewModel) {
        self.viewmodel = viewmodel
        
        businessNameLabel.rac_text <~ viewmodel.businessName.producer
        
        locationLabel.rac_text <~ viewmodel.location.producer
        
        distanceLabel.rac_text <~ viewmodel.eta.producer
            |> ignoreNil
        
        coverImageView.rac_image <~ self.viewmodel.coverImage.producer
            |> ignoreNil
            |> map {
                $0.maskWithRoundedRect(CoverImageSize, cornerRadius: max(CoverImageSize.width, CoverImageSize.height) / 2, borderWidth: 4, opaque: false)
            }
        
        backgroundImageView.rac_image <~ self.viewmodel.coverImage.producer
        
    }
}
