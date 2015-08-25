//
//  PredictiveScrollConductor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import INSPullToRefresh
import ReactiveCocoa

public func predictiveScrolling<T: UITableView, U: IPredictiveScrollDataSource>(tableView: T, withVelocity velocity: CGPoint, #targetContentOffset: UnsafeMutablePointer<CGPoint>, #predictiveScrollable: U) {
    
    // table view is being scrolled down, not up
    if velocity.y > 0.0 &&
        /// Only fetch more data if both pull to refresh and infinity scroll are not already triggered. We don't want to trigger network request repeatedly.
        tableView.ins_pullToRefreshBackgroundView.state != INSPullToRefreshBackgroundViewState.Triggered &&
        tableView.ins_infiniteScrollBackgroundView.state != INSInfiniteScrollBackgroundViewState.Loading {
            
            // targetContentOffset is the offset of the top-left point of the top of the cells that are being displayed
            let contentHeight = targetContentOffset.memory.y
            // height of the table
            let tableHeight = tableView.bounds.size.height
            // content inset
            let contentInsetBottom = tableView.contentInset.bottom
            // get the index path of the bottom cell that is being displayed on table view
            let indexPath = tableView.indexPathForRowAtPoint(CGPoint(x: 0.0, y: contentHeight + tableHeight - contentInsetBottom))
            
            if let row = indexPath?.row {
                predictiveScrollable.predictivelyFetchMoreData(row)
                    |> on(next: { _ in
                        MiscLogVerbose("'PredictiveScrolling' fetched additional data for infinite scrolling.")
                    })
                    |> start()
            }
    }

    
}