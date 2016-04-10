//
//  IBusinessDetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import RxSwift
import RxCocoa

public protocol IBusinessDetailViewModel : class {
    
    // MARK: Outputs
    var businessName: ConstantProperty<String> { get }
    var webSiteURL: ConstantProperty<NSURL?> { get }
    var businessImageURL: NSURL? { get }
    var city: String { get }
    func calculateEta() -> Driver<String>

    
//    var headerViewModel: SocialBusinessHeaderViewModel { get }
    var descriptionViewModel: DescriptionCellViewModel { get }
    var detailAddressAndMapViewModel: DetailAddressAndMapViewModel { get }
    var detailPhoneWebViewModel: DetailPhoneWebViewModel { get }
    var detailNavigationMapViewModel: DetailNavigationMapViewModel { get }
    var businessHourViewModel: BusinessHourCellViewModel { get }
    
    
    // MARK: Actions
    func callPhone() -> SignalProducer<Bool, NoError>
}