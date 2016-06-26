//
//  Region.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-18.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation

public class Region {
    // dummy data for now
    
    public let code: String
    public let countryCode: String
    public let regionNameE: String
    public let regionNameC: String
    public let level: RegionLevel
    public let upperRegion: String
    
    init(code: String) {
        self.code = code
        countryCode = "CN"
        regionNameE = "beijingshi"
        regionNameC = "北京市"
        level = RegionLevel.One
        upperRegion = "0"
    }
}

public enum RegionLevel : Int {
    case One = 1
    case Two = 2
    case Three = 3
    case Four = 4
}