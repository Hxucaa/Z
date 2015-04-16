//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm
import SwiftTask
import ReactKit

public class FeaturedListViewModel : BaseViewModel, IFeaturedListViewModel {
    
    /// Lazily evaluated list of featured businesses
    private var featured = Business.objectsInRealm(RealmService().defaultRealm, withPredicate: NSPredicate(format: "featured = %@", true))
    
    
    public override init(datamanager: IDataManager, realmService: IRealmService) {
        super.init(datamanager: datamanager, realmService: realmService)
    }
    

    public override func getBusiness() {
        //TODO: support for offline usage.
//        return dm.getFeaturedBusiness()
        prepareDataForSignal(featured)
    }
}