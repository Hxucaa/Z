//
//  TypeAliases.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import AVOSCloud

public typealias CompletionHandler = (() -> Void)
public typealias SaveTask = Task<Int, Bool, NSError>
public typealias PFUser = AVUser
public typealias PFObject = AVObject
public typealias PFGeoPoint = AVGeoPoint
public typealias PFQuery = AVQuery
public typealias PFFile = AVFile
public typealias PFAnonymousUtils = AVAnonymousUtils
public typealias PFSubclassing = AVSubclassing
public typealias PFCloud = AVCloud
public typealias Parse = AVOSCloud
public typealias PFACL = AVACL
public typealias PFRole = AVRole
public typealias PFInstallation = AVInstallation
public typealias PFPush = AVPush
public typealias PFRelation = AVRelation