//
//  ParticipationType.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public final class ParticipationType: AVObject, AVSubclassing {
    
    public enum Property : String {
        case Name = "name"
    }
    
    public override init() {
        super.init()
    }
    
    // Class Name
    public class func parseClassName() -> String! {
        return "ParticipationType"
    }
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged public var name: String
}