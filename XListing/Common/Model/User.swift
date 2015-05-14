//
//  UserDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public class User: AVUser, AVSubclassing {
    public func parseClassName() -> String! {
        return "_User"
    }
    public dynamic var name: String?
    
    // MARK: Constrcutros
    public override class func registerSubclass() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
}