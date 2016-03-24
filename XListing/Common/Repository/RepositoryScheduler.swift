//
//  RepositoryScheduler.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

class Scheduler {
    static let repositoryBackgroundScheduler = QueueScheduler(queue: dispatch_queue_create("repository_queue", nil))
}