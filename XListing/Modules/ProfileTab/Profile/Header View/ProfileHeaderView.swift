//
//  ProfileHeaderView.swift
//  XListing
//
//  Created by Anson on 2015-07-21.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import UIKit
import TZStackView
import Cartography
import TTTAttributedLabel
//import ReactiveCocoa

private let ProfileImageSize = CGSizeMake(83, 83)

final class ProfileHeaderView: UIView {
    
    // MARK: - UI Controls
    private lazy var backgroundImageView: UIView = {
        let imageView = UIImageView(image: UIImage(asset: UIImage.Asset.ProfileHeaderBackground))
        imageView.userInteractionEnabled = true
        imageView.backgroundColor = .whiteColor()
        imageView.opaque = true

        return imageView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(frame: CGRectMake(345, 27, 26, 30))
        button.userInteractionEnabled = true
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 2, bottom: 3, right: 2)
        button.setImage(UIImage(asset: .Edit_Button), forState: .Normal)
        
//        let editAction = Action<UIButton, Void, NoError> { [weak self] button in
//            return SignalProducer { observer, disposable in
//                self?._editObserver.proxyNext(())
//                observer.sendCompleted()
//            }
//        }
//        
//        button.addTarget(editAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 40, y: 64), size: ProfileImageSize))
        imageView.opaque = false
        imageView.backgroundColor = .clearColor()
        
        return imageView
    }()
    
    private lazy var nicknameLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 80, 40))
        label.opaque = false
        label.backgroundColor = .clearColor()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        label.font = UIFont.systemFontOfSize(24)
        label.textColor = UIColor.whiteColor()
        
        label.layer.masksToBounds = false
        label.layer.shouldRasterize = true
        
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize.zero
        label.layer.shadowColor = UIColor.grayColor().CGColor
        
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
        
        let label = AgeGroupLabel(frame: CGRectMake(0, 0, 50, 17))
        label.font = UIFont(name: Fonts.FontAwesome, size: 12)
        label.textInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        return label
        }()
    
    private lazy var whatsUpLabel: TTTAttributedLabel = {
        
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 30, 100))
//        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.backgroundColor = .clearColor()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(13)
//        label.numberOfLines = 2
        
        label.layer.masksToBounds = false
        label.layer.shouldRasterize = true
        
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize.zero
        label.layer.shadowColor = UIColor.grayColor().CGColor
        
        return label
    }()
    
    // MARK: - Properties
    
    // MARK: - Proxies
    var editProxy: SimpleProxy {
        return _editProxy
    }
    private let (_editProxy, _editObserver) = SimpleProxy.proxy()
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(profileImageView)
        backgroundImageView.addSubview(nicknameLabel)
        backgroundImageView.addSubview(ageGroupLabel)
        backgroundImageView.addSubview(horoscopeLabel)
        backgroundImageView.addSubview(whatsUpLabel)
        
        constrain(backgroundImageView) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.bottom == $0.superview!.bottom
        }
        
        constrain(profileImageView) {
            let superview = $0.superview!
            $0.leading == superview.leading + 40
            $0.centerY == superview.centerY + 5
            $0.width == superview.height * 0.50
            $0.height == $0.width
        }
        
        constrain(profileImageView, nicknameLabel) { image, label in
            label.leading == image.trailing + 35
            label.top == image.top
        }
        
        constrain(nicknameLabel) {
            $0.trailing <= $0.superview!.trailingMargin - 15
        }
        
        constrain(nicknameLabel, ageGroupLabel, whatsUpLabel) {
            align(leading: $0, $1, $2)

            $2.top == $1.bottom + 8
            $2.height == 15
        }
        
        constrain(profileImageView, whatsUpLabel) { image, label in
            label.bottom == image.bottom
        }
        
        constrain(whatsUpLabel) {
            $0.trailing <= $0.superview!.trailingMargin - 15
        }
        
        constrain(ageGroupLabel, horoscopeLabel) {
            align(centerY: $0, $1)
            $1.leading == $0.trailing + 25
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    // MARK: - Bindings
    func bindToData(nickname: String, horoscope: Horoscope, ageGroup: AgeGroup, gender: Gender, whatsUp: String?, profileImageURL: NSURL?) {
        nicknameLabel.text = nickname
        horoscopeLabel.text = horoscope.description
        ageGroupLabel.bindToData(ageGroup, gender: gender)
        profileImageView.pin_setImageFromURL(profileImageURL, processorKey: "Profile Page Image") { (result, cost) -> UIImage? in
            result.image?.maskWithRoundedRect(ProfileImageSize, cornerRadius: max(ProfileImageSize.width, ProfileImageSize.height) / 2, borderWidth: 3, opaque: false)
        }
    }
}