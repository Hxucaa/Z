//
//  FeaturedListPresenter.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

class FeaturedListPresenter : IFeaturedListPresenter {
    private let featuredListInteractor: IFeaturedListInteractor
    
    init(featuredListInteractor: IFeaturedListInteractor) {
        self.featuredListInteractor = featuredListInteractor
    }
    
    func getList() -> Task<Int, [FeaturedListDisplayData], NSError> {
        let task = featuredListInteractor.getFeaturedList()
        
        let resultTask = task
            .success { businessDomainArr -> [FeaturedListDisplayData] in
//                println(businessDomainArr)
                var result = businessDomainArr.map { FeaturedListDisplayData(businessDomain: $0) }
                
                // Transform data here if necessary
                
                return result
            }
            .failure { errorInfo -> [FeaturedListDisplayData] in
                println(errorInfo)
                return [FeaturedListDisplayData]()
            }
        
        return resultTask
    }
}