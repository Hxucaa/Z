////
////  DetailPhoneWebViewModel.swift
////  XListing
////
////  Created by Lance Zhu on 2015-06-13.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//import ReactiveCocoa
//
//private let 访问网站 = "访问网站"
//private let 没有网站 = "没有网站"
//
//public final class DetailPhoneWebViewModel {
//    
//    // MARK: - Inputs
//    
//    // MARK: - Outputs
//    public let businessName: ConstantProperty<String>
//    public let phoneDisplay: ConstantProperty<String>
//    public let webSiteDisplay: ConstantProperty<String>
//    
//    // MARK: - API
//    
//    // MARK: - Initializers
//    public init(name: String, phone: String, website: String?) {
//        businessName = ConstantProperty(name)
//        
//        phoneDisplay = ConstantProperty("\(phone)")
//        
//        if website != nil {
//            webSiteDisplay = ConstantProperty("\(访问网站)")
//        }
//        else {
//            webSiteDisplay = ConstantProperty("\(没有网站)")
//        }
//    }
//}