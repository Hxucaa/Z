//
//  Business.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation

public struct Business : IModel {
    public let objectId: String
    public let updatedAt: NSDate
    public let createdAt: NSDate
    
    public let name: String
    public let phone: String
    public let email: String?
    public let websiteUrl: NSURL?
    public let address: Address
    public let coverImage: ImageFile
    public let descriptor: String?
    
    public let aaCount: Int
    public let treatCount: Int
    public let toGoCount: Int
    
//    public init(objectId: String, updatedAt: NSDate, createdAt: NSDate, name: String, phone: String, email: String? = nil, websiteUrl: NSURL?, address: Address, coverImage: ImageFile, descriptor: String?, aaCount: Int, treatCount: Int, toGoCount: Int) {
//        
//        self.name = name
//        self.phone = phone
//        self.email = email
//        self.websiteUrl = websiteUrl
//        self.address = address
//        self.coverImage = coverImage
//        self.descriptor = descriptor
//        
//        self.aaCount = aaCount
//        self.treatCount = treatCount
//        self.toGoCount = toGoCount
//        
//        super.init(objectId: objectId, updatedAt: updatedAt, createdAt: createdAt)
//    }
}