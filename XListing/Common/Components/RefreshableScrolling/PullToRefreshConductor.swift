//
//  PullToRefreshConductor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import INSPullToRefresh
import ReactiveCocoa

private let PullToRefreshHeight: CGFloat = 60.0

public class PullToRefreshConductor<T: UITableView, U: IPullToRefreshDataSource> {
    
    private weak var tableView: T!
    private weak var pullToRefreshable: U!
    
    public init(tableView: T, pullToRefreshable: U) {
        self.tableView = tableView
        self.pullToRefreshable = pullToRefreshable
    }
    
    public func setup() {
        
        /**
        *  Setup the action to Pull to Refresh
        */
        tableView.ins_addPullToRefreshWithHeight(PullToRefreshHeight) { [weak self] scrollView -> Void in
            // When pull to refresh is triggered, fetch more data if not already happening
            if let this = self {
                let startTime = NSDate.timeIntervalSinceReferenceDate()
                this.pullToRefreshable.refreshData()
                    |> on(next: { _ in
                        MiscLogVerbose("Pull to refresh fetched additional data for infinite scrolling.")
                    })
                    |> flatMap(.Merge) { _ -> SignalProducer<Void, NSError> in
                        
                        /**
                        *  Ensure the pull to refresh is displayed for a minimum amount of time even if network request is very fast.
                        */
                        let currentTime = NSDate.timeIntervalSinceReferenceDate()
                        let elapsedTime = currentTime - startTime
                        
                        if elapsedTime < Constants.PULL_TO_REFRESH_DELAY {
                            return SignalProducer<Void, NSError>.empty
                                // delay the signal due to the animation of retracting keyboard
                                // this cannot be executed on main thread, otherwise UI will be blocked
                                |> delay(Constants.PULL_TO_REFRESH_DELAY - elapsedTime, onScheduler: QueueScheduler())
                                // return the signal to main/ui thread in order to run UI related code
                                |> observeOn(UIScheduler())
                        }
                        else {
                            return SignalProducer<Void, NSError>.empty
                        }
                    }
                    |> start(
                        error: { error in
                            scrollView.ins_endPullToRefresh()
                            MiscLogError("Pull to refresh error: \(error)")
                        },
                        completed: {
                            scrollView.ins_endPullToRefresh()
                        }
                    )
            }
        }
        
        /**
        *  Setup the view to Pull to Refresh
        */
        let pullToRefresh = PullToRefresh(coder: CGRectMake(0, 0, 24, 24))
        tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
        tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)
    }
    
    public func removePullToRefresh() {
        tableView.ins_removePullToRefresh()
    }
    
    deinit {
        MiscLogVerbose("PullToRefreshConductor deinitializes.")
    }
}

