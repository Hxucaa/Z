//
//  DetailAddressTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Cartography

public final class DetailAddressTableViewCell: UITableViewCell {

    // MARK: - UI Controls
    private lazy var addressButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "FontAwesome", size: 15)
        button.titleLabel?.textAlignment = NSTextAlignment.Left
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // Action
        let pushNavMap = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    
                    sendNext(this._navigationMapSink, ())
                    
                    sendCompleted(sink)
                }
            }
        }
        
        button.addTarget(pushNavMap.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        return button
    }()
    
    // MARK: - Proxies
    private let (_navigationMapProxy, _navigationMapSink) = SimpleProxy.proxy()
    public var navigationMapProxy: SimpleProxy {
        return _navigationMapProxy
    }
    
    // MARK: - Properties
    private var viewmodel: DetailAddressAndMapViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        
        addSubview(addressButton)
        constrain(addressButton) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.trailing == view.superview!.trailingMargin
            view.height == 44
        }
        
        constrain(addressButton.titleLabel!) { label in
            label.leading == label.superview!.leadingMargin
            label.trailing == label.superview!.trailingMargin
            label.top == label.superview!.topMargin
            label.bottom == label.superview!.bottomMargin
        }
        
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: DetailAddressAndMapViewModel) {
        self.viewmodel = viewmodel
        
        compositeDisposable += self.viewmodel.fullAddress.producer
            |> takeUntilPrepareForReuse(self)
            |> start(next: { [weak self] address in
                self?.addressButton.setTitle(address, forState: UIControlState.Normal)
            })
    }
}
