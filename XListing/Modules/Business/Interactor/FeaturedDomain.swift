//
//  FeaturedDomain.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public struct FeaturedDomain : Printable {
    public var timeStart: NSDate?
    public var timeEnd: NSDate?
    public var business: BusinessEntity?
    
    init(timeStart: NSDate?, timeEnd: NSDate?, business: BusinessEntity?) {
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.business = business
    }
    
    func toEntity() -> FeaturedEntity {
        let entity = FeaturedEntity()
        entity.timeStart = timeStart
        entity.timeEnd = timeEnd
        entity.business = business
        return entity
    }
    
    public var description: String {
        let bdMirror = reflect(self)
        var result = ""
        for var i = 0; i < bdMirror.count; i++ {
            let (propertyName, childMirror) = bdMirror[i]
            
            result += "\(propertyName): \(childMirror.value)\n"
        }
        result += "\n"
        return result
    }
}