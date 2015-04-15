//
//  NearbyViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm
import SwiftTask
import ReactKit

public class NearbyViewModel : BaseViewModel, INearbyViewModel {
    
    /// Lazily evaluated list of featured businesses
    private var businesses = Business.allObjects()
    
    
    public override init(datamanager: IDataManager, realmService: IRealmService) {
        super.init(datamanager: datamanager, realmService: realmService)
    }
    
    
    public override func getBusiness() {
        //TODO: support for offline usage.
        //        return dm.getFeaturedBusiness()
        prepareDataForSignal(businesses)
    }
}