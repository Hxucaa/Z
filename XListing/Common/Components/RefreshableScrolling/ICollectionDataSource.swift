//
//  ICollectionDataSource.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol ICollectionDataSource {
    /// Associated Types
    associatedtype Payload
    
    var collectionDataSource: Driver<[Payload]> { get }
}