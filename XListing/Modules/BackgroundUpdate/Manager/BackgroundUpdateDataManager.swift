//
//  BackgroundUpdateDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class BackgroundUpdateDataManager : IBackgroundUpdateDataManager {
    
    private var backgroundQueue: dispatch_queue_t?
    private var timerSource: dispatch_source_t?
    private let dataManager: IDataManager
    
    init(dataManager: IDataManager) {
        self.dataManager = dataManager
    }
    
    
    public func updateBusinessPeriodicallyInBackground() {
        let timer = 300 + arc4random_uniform(300)
        println("Contact server for update every \(timer) seconds.")
        backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, backgroundQueue!)
        dispatch_source_set_timer(timerSource!, dispatch_time(DISPATCH_TIME_NOW, 0), UInt64(Double(timer) * Double(NSEC_PER_SEC)), 60 * NSEC_PER_SEC)
        dispatch_source_set_event_handler(timerSource!) { [unowned self] () -> Void in
            self.dataManager.getBusiness()
        }
        dispatch_resume(timerSource!)
    }
    
    public func cancelPeriodicUpdateBackgroundOperation() {
        if let timer = timerSource {
            dispatch_source_cancel(timer)
            self.timerSource = nil
        }
    }
}