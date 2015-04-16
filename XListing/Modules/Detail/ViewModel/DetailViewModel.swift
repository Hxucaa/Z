//
//  DetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm
import SwiftTask
import ReactKit

public class DetailViewModel : BaseViewModel, IDetailViewModel {
    
    public override init(datamanager: IDataManager, realmService: IRealmService) {
        super.init(datamanager: datamanager, realmService: realmService)
    }
    
}