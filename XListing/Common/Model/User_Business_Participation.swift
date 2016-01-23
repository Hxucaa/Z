//
//  User_Business_Participation.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public final class User_Business_Participation: AVObject, AVSubclassing {
    
    public enum Property : String {
        case User = "user"
        case Business = "business"
        case ParticipationType = "participationType"
    }
    
    public override init() {
        super.init()
    }
    
    // Class Name
    public class func parseClassName() -> String! {
        return "User_Business_Participation"
    }
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged public var user: User
    
    @NSManaged public var business: Business
    
    // participationType decoding:
    // case AA = 2
    // case Treat = 1
    // case ToGo = 0
    @NSManaged private var participationType: Int
    public var type: ParticipationType {
        get {
            return ParticipationType(rawValue: participationType)!
        }
        set {
            participationType = newValue.rawValue
        }
    }
}