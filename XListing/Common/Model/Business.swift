//
//  BusinessDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public final class Business: AVObject, AVSubclassing {
    
    public struct Property {
        static let name = "name"
        static let phone = "phone"
        static let email = "email"
        static let websiteUrl = "websiteUrl"
        static let address = "address"
        static let coverImage = "coverImage"
        static let descript = "description"
        static let isActive = "isActive"
        static let aaCount = "aaCount"
        static let treatCount = "treatCount"
        static let toGoCount = "toGoCount"
    }
    
    // Class Name
    public class func parseClassName() -> String {
        return "Business"
    }
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    // Simplified Chinese name of this business
    @NSManaged public var name: String
    
    // Phone number for this business with international dialing code (e.g. +442079460000)
    @NSManaged public var phone: String
    
    @NSManaged public var email: String?
    
    // URL for business page
    @NSManaged public var websiteUrl: String?

    @NSManaged public var address: Address

    
    public var coverImage: ImageFile {
        get {
            let file = (self[Property.coverImage] as! AVFile)
            return ImageFile(name: file.name, url: file.url)
        }
    }
    
    public func setCoverImage(name: String, data: NSData) {
        self[Property.coverImage] = AVFile(name: name, data: data)
    }
    
    public var descript: String? {
        get {
            return self[Property.descript] as? String
        }
        set {
            self[Property.descript] = newValue
        }
    }
    
    public var isActive: Activation {
        get {
            return Activation(self[Property.isActive] as! Bool)
        }
        set {
            self[Property.isActive] = newValue.boolValue
        }
    }
    
    @NSManaged public var aaCount: Int
    
    @NSManaged public var treatCount: Int
    
    @NSManaged public var toGoCount: Int
    
}