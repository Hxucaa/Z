//
//  Image.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public struct ImageFile {
    public var url: String?
    public var data: NSData?
    public var name: String?
    
    public init(url: String?) {
        self.url = url
    }
    
    public init(name: String?, data: NSData?) {
        self.name = name
        self.data = data
    }
}