//
//  BusinessDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud
import RxSwift

public final class BusinessDAO: AVObject, AVSubclassing {
    
    struct Property {
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
    @NSManaged var name: String
    
    // Phone number for this business with international dialing code (e.g. +442079460000)
    @NSManaged var phone: String
    
    @NSManaged var email: String?
    
    // URL for business page
    @NSManaged var websiteUrl: String?
    @NSManaged var address: AddressDAO
    @NSManaged var coverImage: AVFile
    
    var descript: String? {
        get {
            return self[Property.descript] as? String
        }
        set {
            self[Property.descript] = newValue
        }
    }
    @NSManaged var aaCount: Int
    @NSManaged var treatCount: Int
    @NSManaged var toGoCount: Int
    
}

extension BusinessDAO {
    static var typedQuery: TypedAVQuery<BusinessDAO> {
        return TypedAVQuery<BusinessDAO>(query: BusinessDAO.query())
    }
}

extension BusinessDAO {
    func openEvent(type: Int) -> Observable<EventDAO> {
        return AVCloud.rx_callFunction("openEvent", withParameters: ["businessId": self.objectId, "event_type": type])
            .map { data in
                let dao = AVObject(dictionary: data) as! EventDAO
                return dao
            }
        
    }
}
