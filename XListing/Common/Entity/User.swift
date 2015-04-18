//
//  User.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm

public class User: RLMObject {
    
    /**
    *  Parse fileds
    */
    public dynamic var objectId: String = ""
    public dynamic var remoteCreatedAt: NSTimeInterval = -1.0
    public dynamic var remoteUpdatedAt: NSTimeInterval = -1.0
    public dynamic var username: String = ""
    public dynamic var password: String = ""
    public dynamic var email: String = ""
    
    /**
    *  User info
    */
    public dynamic var name: String = ""
}