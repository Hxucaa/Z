//
//  FeaturedListInteractor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class FeaturedListInteractor {
    private var listManager = ListManager()
    
    func getFeaturedList(callback: [BusinessDomain] -> Void) {
        listManager.findAListOfFeaturedBusinesses { (list) in
            var bd = list.map {BusinessDomain(business: $0)}
            callback(bd)
        }
    }
}