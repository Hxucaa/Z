//
//  EventParticipation.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation

public struct EventParticipation {
    public let objectId: String
    public let updatedAt: NSDate
    public let createdAt: NSDate
    
    public let participant: User
    public let event: Event
    public let status: EventParticipationStatus
    
}