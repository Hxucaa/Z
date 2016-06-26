//
//  DetailPhoneWebTableViewCell.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-01.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import UIKit
import Cartography
import TZStackView
import TTTAttributedLabel
import RxSwift
import RxCocoa

final class DetailPhoneWebTableViewCell: UITableViewCell {

    // MARK: - UI Controls
    private lazy var phoneIconLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 30, 30))
        label.backgroundColor = .whiteColor()
        label.opaque = true
        label.textColor = .blackColor()
        label.font = UIFont(name: "FontAwesome", size: 16)
        label.textAlignment = .Left
        label.text = "\u{f095}"
        label.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        label.userInteractionEnabled = false
        
        return label
    }()
    
    private lazy var phoneLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 150, 40))
        label.backgroundColor = .whiteColor()
        label.font = UIFont(name: "FontAwesome", size: 16)
        label.opaque = true
        label.textColor = .blackColor()
        label.textAlignment = .Left
        label.adjustsFontSizeToFitWidth = true
        label.userInteractionEnabled = false
        
        return label
    }()
    
    private lazy var phoneStack: UIView = {
        let stack = UIView()
        
        stack.addSubview(self.phoneIconLabel)
        stack.addSubview(self.phoneLabel)
        
        return stack
    }()
    
    private lazy var websiteIconLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 30, 30))
        label.backgroundColor = .whiteColor()
        label.opaque = true
        label.textColor = .blackColor()
        label.font = UIFont(name: "FontAwesome", size: 16)
        label.textAlignment = .Left
        label.text = "\u{f0ac}"
        label.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        label.userInteractionEnabled = false
        
        return label
    }()
    
    private lazy var websiteLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 150, 40))
        label.backgroundColor = .whiteColor()
        label.font = UIFont(name: "FontAwesome", size: 16)
        label.opaque = true
        label.textColor = .blackColor()
        label.textAlignment = .Left
        label.adjustsFontSizeToFitWidth = true
        label.userInteractionEnabled = false
        
        return label
    }()
    
    private lazy var websiteStack: UIView = {
        let stack = UIView()
        
        stack.addSubview(self.websiteIconLabel)
        stack.addSubview(self.websiteLabel)
        stack.userInteractionEnabled = true
        
        return stack
    }()
    
    // MARK: - Outputs
    private var presentWebView: Observable<Void>!
    private var makeACall: Observable<Void>!
    var output: (presentWebView: Observable<Void>, makeACall: Observable<Void>) {
        return (presentWebView, makeACall)
    }
//    private let (_presentWebViewProxy, _presentWebViewObserver) = SimpleProxy.proxy()
//    var presentWebViewProxy: SimpleProxy {
//        return _presentWebViewProxy
//    }
//    
//    private let (_makeACallProxy, _makeACallObserver) = SimpleProxy.proxy()
//    var makeACallProxy: SimpleProxy {
//        return _makeACallProxy
//    }
    
    // MARK: - Properties
    
    // MARK: - Setups
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundView = UIImageView(image: UIImage(named: ImageAssets.divider))
        
        contentView.backgroundColor = .whiteColor()
        contentView.opaque = true
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        selectionStyle = .None
        
        // Initialization code
        
        contentView.addSubview(phoneStack)
        contentView.addSubview(websiteStack)
        
        constrain(phoneStack) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            $0.width == $0.superview!.width / 2
        }
        
        constrain(phoneStack, websiteStack) { phone, website in
            website.leading == phone.trailing
            website.top == website.superview!.top
            website.bottom == website.superview!.bottom
            website.trailing == website.superview!.trailing
        }
        
        func constrainIconAndText(icon: TTTAttributedLabel, text: TTTAttributedLabel) -> Void {
            
            constrain(icon, text) { icon, text in
                align(centerY: icon, text)
                
                icon.leading == icon.superview!.leadingMargin + 16
                icon.centerY == icon.superview!.centerY
                icon.width == 21
                
                icon.trailing == text.leading - 8
                
                text.trailing == text.superview!.trailing
            }
        }
        
        constrainIconAndText(phoneIconLabel, text: phoneLabel)
        constrainIconAndText(websiteIconLabel, text: websiteLabel)
        
        
        let visitWebsite = UITapGestureRecognizer()
        websiteStack.addGestureRecognizer(visitWebsite)
        
        presentWebView = visitWebsite.rx_event.asObservable()
            .map { _ in }
        
        
        let makeACallTap = UITapGestureRecognizer()
        phoneStack.addGestureRecognizer(makeACallTap)
        
        makeACall = makeACallTap.rx_event.asObservable()
            .map { _ in }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bindings
    
    func bindToData(phoneDisplay: String, websiteDisplay: String) {
        
        phoneLabel.text = phoneDisplay
        
        websiteLabel.text = websiteDisplay
    }
}
