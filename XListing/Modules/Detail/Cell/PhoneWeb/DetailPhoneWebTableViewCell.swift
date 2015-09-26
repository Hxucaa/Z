//
//  DetailPhoneWebTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Cartography

public final class DetailPhoneWebTableViewCell: UITableViewCell {

    // MARK: - UI Controls
    private lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "FontAwesome", size: 15)
        button.titleLabel?.textAlignment = NSTextAlignment.Left
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    private lazy var websiteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "FontAwesome", size: 15)
        button.titleLabel?.textAlignment = NSTextAlignment.Left
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    // MARK: - Proxies
    private let (_presentWebViewProxy, _presentWebViewSink) = SignalProducer<UIViewController, NoError>.proxy()
    public var presentWebViewProxy: SignalProducer<UIViewController, NoError> {
        return _presentWebViewProxy
    }
    
    // MARK: - Properties
    private var viewmodel: DetailPhoneWebViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundView = UIImageView(image: UIImage(named: ImageAssets.divider))
        
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        
        // Initialization code
        
        setupWebsiteButton()
        addSubview(websiteButton)
        setupPhoneButton()
        addSubview(phoneButton)
        
        constrain(phoneButton, websiteButton) { phone, website in
            phone.leading == phone.superview!.leadingMargin
            website.trailing == website.superview!.trailingMargin
            phone.trailing == website.leading
            
            phone.height == 44
            website.height == 44
            
            phone.width == phone.superview!.width/2
            website.width == website.superview!.width/2
            
            phone.top == phone.superview!.top
            phone.bottom == phone.superview!.bottom
            website.top == website.superview!.top
            website.bottom == website.superview!.bottom

        }
        
        constrain(phoneButton.titleLabel!) { label in
            label.leading == label.superview!.leadingMargin
            label.trailing == label.superview!.trailingMargin
            label.top == label.superview!.topMargin
            label.bottom == label.superview!.bottomMargin
        }
        
        constrain(websiteButton.titleLabel!) { label in
            label.leading == label.superview!.leadingMargin
            label.trailing == label.superview!.trailingMargin
            label.top == label.superview!.topMargin
            label.bottom == label.superview!.bottomMargin
        }
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupWebsiteButton() {
        
        let goToWebsite = Action<UIButton, Void, NoError> { button in
            return self.viewmodel.webSiteURL.producer
                |> ignoreNil
                |> map { url -> Void in
                    let webVC = DetailWebViewViewController(url: url, businessName: self.viewmodel.businessName.value)
                    let navController = UINavigationController()
                    navController.pushViewController(webVC, animated: true)
                    
                    sendNext(self._presentWebViewSink, navController)
                }
        }
        
        websiteButton.addTarget(goToWebsite.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupPhoneButton() {
        
        let callPhone = Action<UIButton, Void, NoError> { button in
            return self.viewmodel.callPhone
        }
        
        phoneButton.addTarget(callPhone.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    deinit {
        compositeDisposable.dispose()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        compositeDisposable.dispose()
    }
    
    // MARK: Bindings
    
    public func bindToViewModel(viewmodel: DetailPhoneWebViewModel) {
        self.viewmodel = viewmodel
        
        compositeDisposable += self.viewmodel.phoneDisplay.producer
            |> takeUntilPrepareForReuse(self)
            |> start(next: { [weak self] phoneDisplay in
                self?.phoneButton.setTitle(phoneDisplay, forState: .Normal)
            })
        
        compositeDisposable += self.viewmodel.webSiteDisplay.producer
            |> takeUntilPrepareForReuse(self)
            |> start(next: { [weak self] websiteDisplay in
                self?.websiteButton.setTitle(websiteDisplay, forState: .Normal)
            })
    }
}
