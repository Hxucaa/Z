//
//  EventParticipationDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

final class EventParticipationDAO: AVObject, AVSubclassing {
    
    enum Property : String {
        case Event = "event"
        case Participant = "participant"
        case Status = "status"
    }
    
    private(set) var status: IntAttribute!
    
    override init() {
        super.init()
        
        status = IntAttribute(propertyName: "status", dao: self)
    }
    
    // Class Name
    class func parseClassName() -> String! {
        return "Event_Participation"
    }
    
    // MARK: Constructors
    override class func registerSubclass() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged var event: EventDAO
    
    @NSManaged var participant: UserDAO
    
//    @NSManaged var status: Int
    
}

extension EventParticipationDAO {
    static var typedQuery: TypedAVQuery<EventParticipationDAO> {
        return TypedAVQuery<EventParticipationDAO>(query: EventParticipationDAO.query())
    }
}
