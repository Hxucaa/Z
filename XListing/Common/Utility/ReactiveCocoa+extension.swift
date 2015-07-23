//
//  ReactiveCocoa+extension.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

/**
Converts to a SignalProducer with `Void` value and `NoError`
*/
public func toNihil<T, E>(producer: SignalProducer<T, E>) -> SignalProducer<Void, NoError> {
    return producer
        |> map { _ in }
        |> catch { error in SignalProducer<Void, NoError>.empty }
}