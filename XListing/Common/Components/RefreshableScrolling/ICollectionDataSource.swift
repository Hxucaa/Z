//
//  ICollectionDataSource.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray

public protocol ICollectionDataSource {
    /// Associated Types
    typealias Payload
    
    var collectionDataSource: ReactiveArray<Payload> { get }
}