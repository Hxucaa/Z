//
//  IImageService.swift
//  XListing
//
//  Created by William Qi on 2015-07-14.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IImageService {
    func getImage(url: NSURL) -> SignalProducer<UIImage, NSError>
}