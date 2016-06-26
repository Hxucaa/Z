//
//  Event.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation


public struct Event : IModel {
    
    public let objectId: String
    public let updatedAt: NSDate
    public let createdAt: NSDate
    
    public let initiator: User
    public let business: Business
    public let finalParticipant: User
    public let type: EventType
    public let status: EventStatus
    
//    public init(objectId: String, updatedAt: NSDate, createdAt: NSDate, initiator: User, business: Business, finalParticipant: User, type: EventType, status: EventStatus) {
//        
//        self.initiator = initiator
//        self.business = business
//        self.finalParticipant = finalParticipant
//        self.type = type
//        self.status = status
//        
//        super.init(objectId: objectId, updatedAt: updatedAt, createdAt: createdAt)
//    }
}
