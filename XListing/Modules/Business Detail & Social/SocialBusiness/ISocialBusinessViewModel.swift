//
//  ISocialBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol ISocialBusinessViewModel : class {
    
    // MARK: - Inputs
    var fetchMoreTrigger: PublishSubject<Void> { get }
    
    // MARK: - Outputs

    var collectionDataSource: Driver<[SectionModel<String, UserInfo>]> { get }
    var businessName: String { get }
    var businessImageURL: NSURL? { get }
    var city: String { get }
    
    // MARK: - Initializers
    
    func calculateEta() -> Driver<String>
    
}