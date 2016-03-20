//
//  _BaseModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation

public protocol IModel {
    var objectId: String { get }
    var updatedAt: NSDate { get }
    var createdAt: NSDate { get }
}

//public class _BaseModel {
//    public let objectId: String
//    public let updatedAt: NSDate
//    public let createdAt: NSDate
//    
//    //    public let isActive: Activation
//    
//    public init(objectId: String, updatedAt: NSDate, createdAt: NSDate) {
//        self.objectId = objectId
//        self.updatedAt = updatedAt
//        self.createdAt = createdAt
//        //        self.isActive = isActive
//    }
//}