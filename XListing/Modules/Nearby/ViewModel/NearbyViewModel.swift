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

public class NearbyViewModel : INearbyViewModel {
    
    private var dm: IDataManager
    
    private var realmService: IRealmService
    
    /// notification token from Realm
    private var token: RLMNotificationToken?
    
    /// wrapper for an array of BusinessViewModel
    public let businessVMArr = DynamicArray()
    
    public init(datamanager: IDataManager, realmService: IRealmService) {
        dm = datamanager
        self.realmService = realmService
        
        setupRLMNotificationToken()
    }
    
    /**
    Subscribe to Realm notification.
    */
    private func setupRLMNotificationToken() {
        
    }
}