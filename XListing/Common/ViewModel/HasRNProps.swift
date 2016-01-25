//
//  HasRNProps.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-24.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol HasRNProps {
    var props: SignalProducer<RNProps, NoError> { get }
}