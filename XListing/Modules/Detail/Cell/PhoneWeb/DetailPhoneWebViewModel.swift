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
    
    // MARK: - Public
    
    // MARK: Outputs
    public let businessName: ConstantProperty<String>
    public let phoneDisplay: ConstantProperty<String>
    public let phoneURL: ConstantProperty<NSURL?>
    public let webSiteDisplay: ConstantProperty<String>
    public let webSiteURL: ConstantProperty<NSURL?>
    
    // MARK: Actions    
    public var callPhone: SignalProducer<Void, NoError> {
        return self.phoneURL.producer
            |> filter { $0 != nil }
            |> map { url -> Void in
                UIApplication.sharedApplication().openURL(url!)
            }
    }
    
    // MARK: Initializers
    public init(businessName: String?, phone: String?, website: String?) {
        self.businessName = ConstantProperty(businessName!)
        if let phone = phone {
            phoneDisplay = ConstantProperty("   \(PhoneIcon)   \(phone)")
            phoneURL = ConstantProperty(NSURL(string: "telprompt://\(phone)"))
        }
        else {
            phoneDisplay = ConstantProperty("   \(PhoneIcon)   \(没有电话)")
            phoneURL = ConstantProperty(nil)
        }
        if let website = website {
            webSiteDisplay = ConstantProperty("   \(WebSiteIcon)   \(访问网站)")
            webSiteURL = ConstantProperty(NSURL(string: website))
        }
        else {
            webSiteDisplay = ConstantProperty("   \(WebSiteIcon)   \(没有网站)")
            webSiteURL = ConstantProperty(nil)
        }
    }
}