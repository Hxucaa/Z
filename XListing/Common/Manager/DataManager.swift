//
//  DataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import Realm

public class DataManager : IDataManager {
    
    private let realmService: IRealmService
    private let businessService: IBusinessService
    private let realmWritter: IRealmWritter
    
    init(businessService: IBusinessService, realmService: IRealmService, realmWritter: IRealmWritter) {
        self.businessService = businessService
        self.realmService = realmService
        self.realmWritter = realmWritter
    }
    
    public func getFeaturedBusiness() -> Task<Int, Void, NSError> {
        return fetchBusinessFromNetwork(realmService.defaultRealm)
    }
    
    public func getBusiness() {
        fetchBusinessFromNetwork(realmService.defaultRealm)
    }
    
    private func fetchBusinessFromNetwork(realm: RLMRealm, query: PFQuery = BusinessDAO.query()!) -> Task<Int, Void, NSError> {

        let task = Task<Int, Void, NSError> { progress, fulfill, reject, econfigure in
            
            let businesses = self.businessService.findBy(query).success { busDaoArr -> Void in
                self.realmWritter.saveBusinessDaosToRealm(realm, withDaoArray: busDaoArr)
            }
        }
        
        return task
    }
}