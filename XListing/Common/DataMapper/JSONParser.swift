//
//  JSONParser.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-08.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import Argo
import Curry

extension Gender : Decodable {}
extension Geolocation : Decodable {
    
    private static func create(latitude: Double) -> Double -> Geolocation {
        return { a in
            Geolocation(latitude: latitude, longitude: a)
        }
    }
    
    public static func decode(j: JSON) -> Decoded<Geolocation> {
        return Geolocation.create
            <^> j <| "latitude"
            <*> j <| "longitude"
    }
}