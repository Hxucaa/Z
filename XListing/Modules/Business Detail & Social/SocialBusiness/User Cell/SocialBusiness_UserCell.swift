//
//  SocialBusiness_UserCell.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import TZStackView
import Cartography
import TTTAttributedLabel
import PINRemoteImage

final class SocialBusiness_UserCell : UITableViewCell {
    
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
        
        let label = UILabel(frame: CGRectMake(0, 0, 68, 17))
        label.opaque = true
        label.backgroundColor = .whiteColor()
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private lazy var participationTypeLabel: UILabel = {
        
        let label = UILabel(frame: CGRectMake(0, 0, 50, 17))
        label.opaque = true
        label.backgroundColor = .whiteColor()
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
    
    private lazy var ageGroupLabel: AgeGroupLabel = {
        
        let label = AgeGroupLabel(frame: CGRectMake(0, 0, 50, 17))
        label.font = UIFont(name: Fonts.FontAwesome, size: 12)
        label.textInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        return label
    }()
    
    private lazy var horoscopeLabel: UILabel = {
        
        let label = UILabel(frame: CGRectMake(0, 0, 50, 17))
        label.opaque = true
        label.backgroundColor = .whiteColor()
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
        label.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        label.textColor = UIColor(hex: "B4B4B4")
        label.font = UIFont.systemFontOfSize(12)
        label.numberOfLines = 3
        // TODO: Fix the performance issue caused by cornerRadius
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        
        return label
    }()
    
    // MARK: - Properties
    
    private var cellData: UserInfo!
    
    // MARK: - Initializers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .whiteColor()
        selectionStyle = UITableViewCellSelectionStyle.None
        
        addSubview(profileImageView)
        addSubview(nicknameAndTypeContainer)
        addSubview(ageGroupAndHoroscopeContainer)
        
        if statusLabel.text != nil {
            addSubview(statusLabel)
            constrain(statusLabel) { view in
                view.width == self.bounds.size.width * 0.3
                view.centerY == view.superview!.centerY
                view.trailing == view.superview!.trailingMargin
            }
            statusLabel.setContentCompressionResistancePriority(750 - 1, forAxis: .Horizontal)
            
        }
        
        constrain(profileImageView) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin + 5
            view.bottom == view.superview!.bottomMargin - 5
            view.width == view.height
        }
        
        constrain(nicknameAndTypeContainer, ageGroupAndHoroscopeContainer, profileImageView) { nicknameAndType, ageGroupAndHoroscope, image in
            align(leading: nicknameAndType, ageGroupAndHoroscope)
            nicknameAndType.leading == image.trailing + 10
            nicknameAndType.top == nicknameAndType.superview!.topMargin + 10
            nicknameAndType.height == 17
            ageGroupAndHoroscope.bottom == ageGroupAndHoroscope.superview!.bottomMargin - 10
            ageGroupAndHoroscope.height == 17
        }
        

        profileImageView.setContentCompressionResistancePriority(750 + 1, forAxis: .Horizontal)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups

    // MARK: - Bindings
    
    func bindToCellData(data: UserInfo) {
        self.cellData = data
        
        nicknameLabel.text = cellData.nickname
        // FIXME: placeholder
        participationTypeLabel.text = "wtf"
        ageGroupLabel.text = cellData.ageGroup.description
        horoscopeLabel.text = cellData.horoscope.description
        statusLabel.text = cellData.whatsUp
        // FIXME: placeholder
        ageGroupLabel.backgroundColor = .redColor()
        // TODO: make image round??
        profileImageView.pin_setImageFromURL(cellData.coverPhotoURL)
        
    }
}
