//
//  FeaturedListPresenter.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

class FeaturedListPresenter {
    private var featuredListInteractor = FeaturedListInteractor()
    
//    func getList(callback: ([FeaturedListDisplayData], NSError?) -> Void) {
//        featuredListInteractor.getFeaturedList { (businessDomain, error) in
//            var fldp = businessDomain.map {FeaturedListDisplayData(businessDomain: $0)}
//            callback(fldp, error)
//        }
//    }
    
    func getList() -> Task<Int, [FeaturedListDisplayData], NSError> {
        let task = featuredListInteractor.getFeaturedList()
        
        let resultTask = task
            .success { businessDomainArr -> [FeaturedListDisplayData] in
                println(businessDomainArr)
                var result = businessDomainArr.map { FeaturedListDisplayData(businessDomain: $0) }
                
                // Transform data here if necessary
                
                return result
            }
            .failure { errorInfo -> [FeaturedListDisplayData] in
                return [FeaturedListDisplayData]()
            }
        
        return resultTask
    }
}