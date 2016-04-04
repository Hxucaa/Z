//
//  IFeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray
import RxSwift
import RxCocoa

protocol IFeaturedListViewModel {
    
    // MARK: - Outputs
    var collectionDataSource: Driver<[BusinessInfo]> { get }
}