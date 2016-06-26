//
//  RepositorySchedulers.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
#endif

public protocol IWorkSchedulers {
    var background: ImmediateSchedulerType { get }
    var main: SerialDispatchQueueScheduler { get }
}

public class WorkSchedulers : IWorkSchedulers {
    
    public let background: ImmediateSchedulerType
    public let main: SerialDispatchQueueScheduler
    
    public init() {
        
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        #if !RX_NO_MODULE
            operationQueue.qualityOfService = NSQualityOfService.UserInitiated
        #endif
        background = OperationQueueScheduler(operationQueue: operationQueue)
        
        main = MainScheduler.instance
    }
}