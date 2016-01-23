//
//  DetailPhoneWebViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

private let PhoneIcon = "\u{f095}"
private let 没有电话 = "没有电话"
private let WebSiteIcon = "\u{f0ac}"
private let 访问网站 = "访问网站"
private let 没有网站 = "没有网站"

public struct DetailPhoneWebViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    private let _businessName: ConstantProperty<String>
    public var businessName: AnyProperty<String> {
        return AnyProperty(_businessName)
    }
    private let _phoneDisplay: ConstantProperty<String>
    public var phoneDisplay: AnyProperty<String> {
        return AnyProperty(_phoneDisplay)
    }
    private let _phoneURL: ConstantProperty<NSURL?>
    public var phoneURL: AnyProperty<NSURL?> {
        return AnyProperty(_phoneURL)
    }
    private let _webSiteDisplay: ConstantProperty<String>
    public var webSiteDisplay: AnyProperty<String> {
        return AnyProperty(_webSiteDisplay)
    }
    private let _webSiteURL: ConstantProperty<NSURL?>
    public var webSiteURL: AnyProperty<NSURL?> {
        return AnyProperty(_webSiteURL)
    }
    
    // MARK: - API
    public var callPhone: SignalProducer<Void, NoError> {
        return self.phoneURL.producer
            .filter { $0 != nil }
            .map { url -> Void in
                UIApplication.sharedApplication().openURL(url!)
            }
    }
    
    // MARK: - Initializers
    public init(name: String, phone: String?, website: String?) {
        self._businessName = ConstantProperty(name)
        if let phone = phone {
            _phoneDisplay = ConstantProperty("   \(PhoneIcon)   \(phone)")
            _phoneURL = ConstantProperty(NSURL(string: "telprompt://\(phone)"))
        }
        else {
            _phoneDisplay = ConstantProperty("   \(PhoneIcon)   \(没有电话)")
            _phoneURL = ConstantProperty(nil)
        }
        if let website = website {
            _webSiteDisplay = ConstantProperty("   \(WebSiteIcon)   \(访问网站)")
            _webSiteURL = ConstantProperty(NSURL(string: website))
        }
        else {
            _webSiteDisplay = ConstantProperty("   \(WebSiteIcon)   \(没有网站)")
            _webSiteURL = ConstantProperty(nil)
        }
    }
}