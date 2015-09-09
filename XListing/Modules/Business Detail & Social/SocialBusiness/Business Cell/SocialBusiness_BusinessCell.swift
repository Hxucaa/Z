//
//  SocialBusiness_BusinessCell.swift
//  XListing
//
//  Created by Anson on 2015-09-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import TZStackView
import Cartography
import TTTAttributedLabel

public final class SocialBusiness_BusinessCell : UITableViewCell {
    
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
        
        let container = TZStackView(arrangedSubviews: [self.coverImageView, self.businessNameLabel, self.cuisineLabel, self.locationAndDistanceContainer])
        container.distribution = TZStackViewDistribution.EqualSpacing
        container.axis = .Vertical
        container.spacing = 8
        container.alignment = .Center
        
        return container
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ImageAssets.profilepicture)?.maskWithRoundedRect(CGSizeMake(100, 100), cornerRadius: 40, borderWidth: 4, opaque: false))
        imageView.opaque = false
        imageView.backgroundColor = UIColor.clearColor()
        
        constrain(imageView) { view in
            view.width == 100
            view.height == 100
        }
        
        return imageView
    }()
    
    private lazy var businessNameLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 70, 40))
        label.opaque = false
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(25)
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
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None
        
        backgroundImageView.image = UIImage(named: ImageAssets.lowPoly)
        businessNameLabel.text = "老四川"
        cuisineLabel.text = "川菜"
        locationLabel.text = "Richmond"
        distanceLabel.text = "30分钟"
        
        
        addSubview(backgroundImageView)
        addSubview(mainContainer)
        
        constrain(backgroundImageView) { view in
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
        }
        
        constrain(dividerView, locationLabel) { divider, location in
            divider.width == 1
            divider.height == location.height
        }
        
        constrain(mainContainer) { view in
            view.centerX == view.superview!.centerX
            view.centerY == view.superview!.centerY
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups

}
