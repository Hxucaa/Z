//
//  BusinessDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

final class BusinessDAO: AVObject, AVSubclassing {
    
    internal struct Property {
        static let name = "name"
        static let phone = "phone"
        static let email = "email"
        static let websiteUrl = "websiteUrl"
        static let address = "address"
        static let coverImage = "coverImage"
        static let descript = "description"
        //        static let isActive = "isActive"
        static let aaCount = "aaCount"
        static let treatCount = "treatCount"
        static let toGoCount = "toGoCount"
    }
    
    // Class Name
    internal class func parseClassName() -> String {
        return "Business"
    }
    
    // MARK: Constructors
    internal override class func registerSubclass() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    // Simplified Chinese name of this business
    @NSManaged internal var name: String
    
    // Phone number for this business with international dialing code (e.g. +442079460000)
    @NSManaged internal var phone: String
    
    @NSManaged internal var email: String?
    
    // URL for business page
    @NSManaged internal var websiteUrl: String?
    
    @NSManaged internal var address: AddressDAO
    
    @NSManaged internal var coverImage: AVFile
    //    internal var coverImage: ImageFile {
    //        get {
    //            let file = (self[Property.coverImage] as! AVFile)
    //            return ImageFile(name: file.name, url: file.url)
    //        }
    //    }
    
    //    internal func setCoverImage(name: String, data: NSData) {
    //        self[Property.coverImage] = AVFile(name: name, data: data)
    //    }
    
    internal var descript: String? {
        get {
            return self[Property.descript] as? String
        }
        set {
            self[Property.descript] = newValue
        }
    }
    
    //    internal var isActive: Bool
    
    @NSManaged internal var aaCount: Int
    
    @NSManaged internal var treatCount: Int
    
    @NSManaged internal var toGoCount: Int
    
}

//extension BusinessDAO {
//
//    internal func rx_refresh() -> Observable<BusinessDAO> {
//        return super.rx_refresh()
//            .map { $0 as! BusinessDAO }
//    }
//}