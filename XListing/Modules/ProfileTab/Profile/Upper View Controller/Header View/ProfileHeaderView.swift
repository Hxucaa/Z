//
//  ProfileHeaderView.swift
//  XListing
//
//  Created by Anson on 2015-07-21.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import TZStackView
import Cartography
import TTTAttributedLabel
import ReactiveCocoa

private let ProfileImageSize = CGSizeMake(83, 83)

public final class ProfileHeaderView: UIView {
    
    // MARK: - UI Controls
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ImageAssets.profileHeaderBackground))
        imageView.userInteractionEnabled = true
        imageView.backgroundColor = .whiteColor()
        imageView.opaque = true
        
        return imageView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(frame: CGRectMake(345, 27, 26, 30))
        button.userInteractionEnabled = true
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 2, bottom: 3, right: 2)
        button.setImage(UIImage(named: ImageAssets.editIcon), forState: .Normal)
        
        let editAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    proxyNext(this._editSink, ())
                }
                sendCompleted(sink)
            }
        }
        
        button.addTarget(editAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 40, y: 64), size: ProfileImageSize))
        imageView.opaque = false
        imageView.backgroundColor = .clearColor()
        
        return imageView
    }()
    
    private lazy var nicknameLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 80, 30))
        label.opaque = false
        label.backgroundColor = .clearColor()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        label.textColor = UIColor.whiteColor()
        
        return label
    }()
    
    private lazy var horoscopeLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 80, 30))
        label.opaque = false
        label.backgroundColor = .clearColor()
        label.textColor = UIColor.whiteColor()
       
        return label
        
    }()
    
    private lazy var ageGroupLabel: AgeGroupLabel = {
        
        let label = AgeGroupLabel(frame: CGRectMake(0, 0, 50, 22))
        label.font = UIFont(name: Fonts.FontAwesome, size: 14)
        return label
    }()
    
    private lazy var statusLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 30, 100))
//        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.backgroundColor = .clearColor()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(15)
//        label.numberOfLines = 2
        
        return label
    }()
    
    // MARK: - Properties
    private var viewModel: IProfileHeaderViewModel!
    
    // MARK: - Proxies
    public var editProxy: SimpleProxy {
        return _editProxy
    }
    private let (_editProxy, _editSink) = SimpleProxy.proxy()
    
    
    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(editButton)
        backgroundImageView.addSubview(profileImageView)
        backgroundImageView.addSubview(nicknameLabel)
        backgroundImageView.addSubview(ageGroupLabel)
        backgroundImageView.addSubview(horoscopeLabel)
        backgroundImageView.addSubview(statusLabel)
        
        constrain(backgroundImageView) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.bottom == $0.superview!.bottom
        }
        
        constrain(editButton) {
            $0.width == 26
            $0.height == 30
            $0.trailing == $0.superview!.trailingMargin
            $0.top == $0.superview!.top + 25
        }
        
        constrain(profileImageView) {
            let superview = $0.superview!
            $0.leading == superview.leading + 40
            $0.centerY == superview.centerY + 15
            $0.width == superview.height * 0.50
            $0.height == $0.width
        }
        
        constrain(profileImageView, nicknameLabel) { image, label in
            label.leading == image.trailing + 35
            label.top == image.top - 10
        }
        
        constrain(nicknameLabel) {
            $0.trailing <= $0.superview!.trailingMargin - 15
        }
        
        constrain(nicknameLabel, ageGroupLabel, statusLabel) {
            align(leading: $0, $1, $2)
            let superview = $0.superview!
            $1.top == $0.bottom + 25
            $2.top == $1.bottom + 24
            
        }
        
        constrain(statusLabel) {
            $0.trailing <= $0.superview!.trailingMargin - 15
        }
        
        constrain(ageGroupLabel, horoscopeLabel) {
            align(centerY: $0, $1)
            $1.leading == $0.trailing + 25
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: IProfileHeaderViewModel) {
        self.viewModel = viewmodel
        
        nicknameLabel.rac_text <~ viewmodel.nickname
        
        horoscopeLabel.rac_text <~ viewmodel.horoscope
        
        ageGroupLabel.rac_text <~ viewmodel.ageGroup
        
        statusLabel.rac_text <~ viewmodel.status
        
        ageGroupLabel.rac_backgroundColor <~ viewmodel.ageGroupBackgroundColor.producer
            .map { Optional.Some($0) }

        profileImageView.rac_image <~ self.viewModel.profileImage.producer
            .ignoreNil
            .map { $0.maskWithRoundedRect(ProfileImageSize, cornerRadius: max(ProfileImageSize.width, ProfileImageSize.height) / 2, borderWidth: 3, opaque: false) }
    }
}