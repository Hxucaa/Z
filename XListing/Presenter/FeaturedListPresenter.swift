//
//  FeaturedListPresenter.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class FeaturedListPresenter {
    private var featuredListInteractor = FeaturedListInteractor()
    
    func getList(callback: ([FeaturedListDisplayData], NSError?) -> Void) {
        featuredListInteractor.getFeaturedList { (businessDomain, error) in
            var fldp = businessDomain.map {FeaturedListDisplayData(businessDomain: $0)}
            callback(fldp, error)
        }
    }
}