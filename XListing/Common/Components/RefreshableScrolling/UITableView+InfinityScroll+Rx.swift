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
import RxSwift

public typealias FetchMoreTrigger = Observable<Void>

// TODO: Make this number configurable in a centralized place
private let startLoadingOffset: CGFloat = 20.0

extension UITableView {
    private func isNearTheBottomEdge(contentOffset: CGPoint) -> Bool {
        return contentOffset.y + frame.size.height + startLoadingOffset > contentSize.height
    }
    
    /**
     Send a signal when the content of the table view is closed to be depleted.
     
     - parameter offset: A offset of how far off from the bottom of the content should the signal be sent.
     
     - returns: A observable sequence.
     */
    public func rx_closeToLastContent(offset: CGFloat = startLoadingOffset) -> Observable<Void> {
        return rx_contentOffset
            .flatMap { offset in
                self.isNearTheBottomEdge(offset)
                    ? Observable.just(())
                    : Observable.empty()
            }
    }
}
//
//private let InfinityScrollHeight: CGFloat = 60.0
//
//public class InfinityScrollConductor<T: UITableView, U: IInfinityScrollDataSource> {
//    
//    private weak var tableView: T!
//    private weak var infinityScrollable: U!
//    
//    public init(tableView: T, infinityScrollable: U) {
//        self.tableView = tableView
//        self.infinityScrollable = infinityScrollable
//    }
//    
//    public func setup() {
//        
//        /**
//        *  Setup the action to infinity scroll at the bottom
//        */
//        tableView.ins_addInfinityScrollWithHeight(InfinityScrollHeight) { [weak self] scrollView -> Void in
//            // When infinity scroll is triggered, fetch more data if not already happening
//            if let this = self {
//                this.infinityScrollable.fetchMoreData()
//                    .on(next: { _ in
//                        MiscLogVerbose("Infinity scroll fetched additional data for infinite scrolling.")
//                    })
//                    .start { event in
//                        switch event {
//                        case .Failed(let error):
//                            scrollView.ins_endInfinityScroll()
//                            MiscLogError("Infinity scroll error: \(error)")
//                        case .Completed:
//                            scrollView.ins_endInfinityScroll()
//                        default: break
//                        }
//                    }
//            }
//        }
//        
//        /**
//        *  Setup the view to Infinity Scroll
//        */
//        let infinityIndicator = INSDefaultInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
//        tableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)
//        tableView.ins_infiniteScrollBackgroundView.preserveContentInset = false
//        infinityIndicator.startAnimating()
//    }
//    
//    public func removeInfinityScroll() {
//        tableView.ins_removeInfinityScroll()
//    }
//    
//    deinit {
//        MiscLogVerbose("InfinityScrollConductor deinitializes.")
//    }
//}
