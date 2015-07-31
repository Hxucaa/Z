//
//  IBusinessService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public protocol IBusinessService : class {
    func findBy(query: AVQuery) -> SignalProducer<[Business], NSError>
    func getFirst(var query: AVQuery) -> SignalProducer<Business, NSError>
}