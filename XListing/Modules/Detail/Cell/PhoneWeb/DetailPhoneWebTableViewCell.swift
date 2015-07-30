//
//  DetailPhoneWebTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public final class DetailPhoneWebTableViewCell: UITableViewCell {

    // MARK: - UI Controls
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    // MARK: - Proxies
    private let (_presentWebViewProxy, _presentWebViewSink) = SignalProducer<UIViewController, NoError>.proxy()
    public var presentWebViewProxy: SignalProducer<UIViewController, NoError> {
        return _presentWebViewProxy
    }
    
    // MARK: - Properties
    private var viewmodel: DetailPhoneWebViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        setupWebsiteButton()
        setupPhoneButton()
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
