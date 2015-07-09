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

    // MARK: Controls
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    internal weak var delegate: DetailPhoneWebCellDelegate!
    
    private var viewmodel: DetailPhoneWebViewModel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func bindToViewModel(viewmodel: DetailPhoneWebViewModel) {
        self.viewmodel = viewmodel
        
        setupWebsiteButton()
        setupPhoneButton()
    }

    private func setupWebsiteButton() {
        websiteButton?.setTitle(viewmodel.webSiteDisplay.value, forState: .Normal)
        
        let goToWebsite = Action<UIButton, Void, NoError> { [unowned self] button in
            return self.viewmodel.webSiteURL.producer
                |> filter { $0 != nil }
                |> map { [unowned self] url -> Void in
                    let webVC = DetailWebViewViewController(url: url!, businessName: self.viewmodel.businessName.value)
                    let navController = UINavigationController()
                    navController.pushViewController(webVC, animated: true)
                    self.delegate.presentWebView(navController)
                }
        }
        
        websiteButton.addTarget(goToWebsite.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupPhoneButton() {
        phoneButton?.setTitle(viewmodel.phoneDisplay.value, forState: .Normal)
        
        let callPhone = Action<UIButton, Void, NoError> { [unowned self] button in
            return self.viewmodel.callPhone
        }
        
        phoneButton.addTarget(callPhone.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
}
