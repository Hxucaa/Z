//
//  FeaturedListInteractor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

class FeaturedListInteractor {
    private var listManager = ListManager()
    
//    func getFeaturedList(callback: (businesses: [BusinessDomain], error: NSError?) -> Void) {
//        listManager.findAListOfFeaturedBusinesses { (list, error) in
//            var bd = list.map {BusinessDomain(business: $0)}
//            callback(businesses: bd, error: error)
//        }
//    }
    
    func getFeaturedList() -> Task<Int, [BusinessDomain], NSError> {
        
        let task = listManager.findAListOfFeaturedBusinesses()
        
        let resultTask = task
            .success { businessEntities -> [BusinessDomain] in
                let bd = businessEntities.map {BusinessDomain(business: $0)}
                
                return bd
            }
        
        return resultTask
    }
}