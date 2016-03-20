//
//  EventDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

final class EventDAO: AVObject, AVSubclassing {
    
    enum Property : String {
        case Iniator = "initiator"
        case Business = "business"
        case FinalParticipant = "final_participant"
        case EventType = "event_type"
        case Status = "status"
    }
    
    override init() {
        super.init()
    }
    
    // Class Name
    class func parseClassName() -> String! {
        return "Event"
    }
    
    // MARK: Constructors
    override class func registerSubclass() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged var initiator: UserDAO
    
    @NSManaged var business: BusinessDAO
    
    @NSManaged var final_participant: UserDAO
    
    @NSManaged var event_type: Int
    
    @NSManaged var status: Int
    
}