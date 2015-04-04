//
//  FeaturedListInteractor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class FeaturedListInteractor : BusinessInteractor, IFeaturedListInteractor {
    
    public func getFeaturedBusiness() -> Task<Int, [BusinessDomain], NSError> {
        
        let query = BusinessEntity.query()
        query.whereKey("featured", equalTo: true)
        
        return retrieveBusinessWithGeolocation(query)
    }
}