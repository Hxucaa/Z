//
//  DataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class DataManager : IDataManager {
    
    private var realmService: RealmService = RealmService.sharedInstance
    
    public func getFeaturedBusiness() -> Task<Int, Void, NSError> {
        return fetchBusinessFromNetwork()
    }
    
    private func fetchBusinessFromNetwork() -> Task<Int, Void, NSError> {
        let task = Task<Int, Void, NSError> { progress, fulfill, reject, econfigure in
            
            let businesses = BusinessService().findBy().success { busDaoArr -> Void in
                EntityDAOMapper().saveBusinessDaosToRealm(self.realmService.defaultRealm, daoArr: busDaoArr)
            }
        }
        
        return task
    }
}