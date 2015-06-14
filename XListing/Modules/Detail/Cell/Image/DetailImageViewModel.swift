//
//  DetailImageViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public struct DetailImageViewModel {
    public let coverImageNSURL: ConstantProperty<NSURL?>
    
    public init(coverImageURL: String?) {
        if let url = coverImageURL {
            coverImageNSURL = ConstantProperty<NSURL?>(NSURL(string: url))
        }
        else {
            // TODO: fix temp image
            coverImageNSURL = ConstantProperty<NSURL?>(NSURL(string: "http://www.phoenixpalace.co.uk/images/background/aboutus.jpg"))
//            coverImageNSURL = nil
        }
    }
}