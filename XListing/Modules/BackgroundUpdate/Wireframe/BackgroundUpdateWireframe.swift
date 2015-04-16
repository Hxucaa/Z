//
//  BackgroundUpdateWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class BackgroundUpdateWireframe : IBackgroundUpdateWireframe {
    private let backgroundUpdateDM: IBackgroundUpdateDataManager
    
    public init(dataManager: IDataManager) {
        backgroundUpdateDM = BackgroundUpdateDataManager(dataManager: dataManager)
        updateBusinessPeriodicallyInBackground()
    }
    
    public func updateBusinessPeriodicallyInBackground() {
        backgroundUpdateDM.updateBusinessPeriodicallyInBackground()
    }
    
    public func cancelPeriodicUpdateBackgroundOperation() {
        backgroundUpdateDM.cancelPeriodicUpdateBackgroundOperation()
    }
}