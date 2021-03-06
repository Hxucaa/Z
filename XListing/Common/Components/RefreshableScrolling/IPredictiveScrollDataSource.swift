//
//  IPredictiveScrollDataSource.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IPredictiveScrollDataSource : class {
    func predictivelyFetchMoreData(targetContentIndex: Int) -> SignalProducer<Void, NSError>
}
