//
//  SocialBusiness_UserCell.swift
//  XListing
//
//  Created by Anson on 2015-09-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import TZStackView
import Cartography
import TTTAttributedLabel
import ReactiveCocoa

public final class SocialBusiness_UserCell : UITableViewCell {
    
    private var viewmodel: SocialBusiness_UserViewModel!
    
    // MARK: - UI Controls
    
    /**
    *   Left section
    */
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(0, 0, self.frame.height, self.frame.height))
        imageView.opaque = true
        imageView.backgroundColor = UIColor.whiteColor()
        
        return imageView
    }()
    
    /**
    *   Mid section
    */
    
    /// Place nicknameLabel and participationTypeLabel in the container
    private lazy var nicknameAndTypeContainer: TZStackView = {
        
        let container = TZStackView(arrangedSubviews: [self.nicknameLabel, self.participationTypeLabel])
        container.distribution = TZStackViewDistribution.FillProportionally
        container.axis = .Horizontal
        container.spacing = 8
        container.alignment = .Center
        
        return container
    }()
    
    private lazy var nicknameLabel: UILabel = {
        
        let label = UILabel(frame: CGRectMake(0, 0, 68, 25))
        label.opaque = true
        label.backgroundColor = .x_FeaturedCardBG()
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private lazy var participationTypeLabel: UILabel = {
        
        let label = UILabel(frame: CGRectMake(0, 0, 50, 22))
        label.opaque = true
        label.backgroundColor = .x_FeaturedCardBG()
        label.layer.masksToBounds = true
        label.textColor = UIColor.orangeColor()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        
        return label
    }()
    
    /// Place ageGroupLabel and horoscopeLabel in the container
    private lazy var ageGroupAndHoroscopeContainer: TZStackView = {
        
        let container = TZStackView(arrangedSubviews: [self.ageGroupLabel, self.horoscopeLabel])
        container.distribution = TZStackViewDistribution.FillProportionally
        container.axis = .Horizontal
        container.spacing = 8
        container.alignment = .Center
        
        return container
    }()
    
    private lazy var ageGroupLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 50, 22))
        label.opaque = true
        label.backgroundColor = UIColor(red: 223.0/255, green: 68.0/255.0, blue: 154.0/255, alpha: 1.0)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        label.textInsets = UIEdgeInsets(top: 1, left: 7, bottom: 1, right: 7)
        // TODO: Fix the performance issue caused by cornerRadius
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        
        // TODO: May not be correct. Require further investigation.
        label.layer.shouldRasterize = true
        
        return label
    }()
    
    private lazy var horoscopeLabel: UILabel = {
        
        let label = UILabel(frame: CGRectMake(0, 0, 50, 22))
        label.opaque = true
        label.backgroundColor = .x_FeaturedCardBG()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        label.layer.masksToBounds = true
        
        return label
    }()
    
    /**
    *   Right section
    */
    
    private lazy var statusLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 30, 20))
        label.textInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.opaque = true
        label.backgroundColor = UIColor(hex: "F6F6F6")
        label.textColor = UIColor(hex: "B4B4B4")
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 3
        // TODO: Fix the performance issue caused by cornerRadius
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        
        return label
    }()
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .x_FeaturedCardBG()
        selectionStyle = UITableViewCellSelectionStyle.None
        
        ageGroupLabel.text = "90后"
        horoscopeLabel.text = "水瓶座"
        participationTypeLabel.text = "我请客"
        statusLabel.text = "无聊找人吃饭无聊找人吃饭无聊找人"
        
        
        addSubview(profileImageView)
        addSubview(nicknameAndTypeContainer)
        addSubview(ageGroupAndHoroscopeContainer)
        addSubview(statusLabel)
        
        
        constrain(profileImageView) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin
            view.bottom == view.superview!.bottomMargin
            view.width == view.height
        }
        
        constrain(nicknameAndTypeContainer, ageGroupAndHoroscopeContainer, profileImageView) { nicknameAndType, ageGroupAndHoroscope, image in
            align(leading: nicknameAndType, ageGroupAndHoroscope)
            nicknameAndType.leading == image.trailing + 10
            nicknameAndType.top == nicknameAndType.superview!.topMargin
            ageGroupAndHoroscope.bottom == ageGroupAndHoroscope.superview!.bottomMargin
        }
        
        
        constrain(statusLabel) { view in
            view.width == self.bounds.size.width * 0.3
            view.centerY == view.superview!.centerY
            view.trailing == view.superview!.trailingMargin
        }
        
        profileImageView.setContentCompressionResistancePriority(750 + 1, forAxis: .Horizontal)
        statusLabel.setContentCompressionResistancePriority(750 - 1, forAxis: .Horizontal)
        
    }
    
    public func bindViewModel(viewmodel: SocialBusiness_UserViewModel) {
        self.viewmodel = viewmodel
        nicknameLabel.rac_text <~ viewmodel.nickname.producer
            |> takeUntilPrepareForReuse(self)
        
        profileImageView.rac_image <~ viewmodel.profileImage.producer
            |> takeUntilPrepareForReuse(self)
            |> ignoreNil
            |> map { $0.maskWithRoundedRect(self.profileImageView.frame.size, cornerRadius: self.profileImageView.frame.size.height, backgroundColor: .x_FeaturedCardBG()) }
        
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups

}
