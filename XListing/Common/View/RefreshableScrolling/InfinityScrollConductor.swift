//
//  InfinityScrollConductor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import INSPullToRefresh
import ReactiveCocoa

private let InfinityScrollHeight: CGFloat = 60.0

public class InfinityScrollConductor<T: UITableView, U: IInfinityScrollable> {
    
    private weak var tableView: T!
    private weak var infinityScrollable: U!
    
    public init(tableView: T, infinityScrollable: U) {
        self.tableView = tableView
        self.infinityScrollable = infinityScrollable
    }
    
    public func setup() {
        
        /**
        *  Setup the action to infinity scroll at the bottom
        */
        tableView.ins_addInfinityScrollWithHeight(InfinityScrollHeight) { [weak self] scrollView -> Void in
            // When infinity scroll is triggered, fetch more data if not already happening
            if let this = self {
                this.infinityScrollable.fetchMoreData()
                    |> on(next: { _ in
                        FeaturedLogVerbose("Infinity scroll fetched additional data for infinite scrolling.")
                    })
                    |> start(next: { businesses in
                        scrollView.ins_endInfinityScroll()
                    })
            }
        }
        
        /**
        *  Setup the view to Infinity Scroll
        */
        let infinityIndicator = INSDefaultInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        tableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)
        tableView.ins_infiniteScrollBackgroundView.preserveContentInset = false
        infinityIndicator.startAnimating()
    }
    
    deinit {
        DDLogVerbose("InfinityScrollConductor deinitializes.")
    }
}
