//
//  SingleSectionInfiniteTableViewManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-29.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import INSPullToRefresh
import ReactiveCocoa
import ReactiveArray
import Dollar

public class SingleSectionInfiniteTableViewManager<T: UITableView, U: protocol<IPullToRefreshDataSource, IInfinityScrollDataSource, IPredictiveScrollDataSource, ICollectionDataSource>> {
    
    public typealias AppendHandler = (value: U.Payload) -> Void
    public typealias ExtendHandler = (values: [U.Payload]) -> Void
    public typealias InsertHandler = (value: U.Payload, index: Int) -> Void
    public typealias ReplaceHandler = (value: U.Payload, index: Int) -> Void
    public typealias RemoveElementHandler = (index: Int) -> Void
    public typealias ReplaceAllHandler = (values: [U.Payload]) -> Void
    public typealias RemoveAllHandler = (keepCapacity: Bool) -> Void
    
    private weak var tableView: T!
    private let _viewmodel: (Void -> U)
    private var viewmodel: U {
        return _viewmodel()
    }
    private lazy var infinityScrollConductor: InfinityScrollConductor<T, U> = InfinityScrollConductor<T, U>(tableView: self.tableView, infinityScrollable: self.viewmodel)
    private lazy var pullToRefreshConductor: PullToRefreshConductor<T, U> = PullToRefreshConductor<T, U>(tableView: self.tableView, pullToRefreshable: self.viewmodel)
    
    private var isFirstLoad = true
    
    public init(tableView: T, @autoclosure(escaping) viewmodel: () -> U) {
        self.tableView = tableView
        self._viewmodel = viewmodel
        
        infinityScrollConductor.setup()
        pullToRefreshConductor.setup()
    }
    
    /**
    Modify the `SignalProducer` on the `collectionDataSource`. This function accepts several handlers for each of the opeartion that can occur in a `ReactiveArray`. If you don't provide a custom implementation for a handler, the default implementation will get executed.
    
    - parameter targetedSection:      The section number in the table view that should react to change in data source.
    - parameter appendHandler:        `Append` operation
    - parameter extendHandler:        `Extend` operation
    - parameter insertHandler:        `Insert` operation
    - parameter replaceHandler:       `Replace` operation
    - parameter removeElementHandler: `RemoveAtIndex` operation
    - parameter replaceAllHandler:    `ReplaceAll` operation
    - parameter removeAllHandler:     `RemoveAll` operation
    
    - returns: The `SignalProducer`
    */
    public func reactToDataSource(
        targetedSection targetedSection: Int,
        appendHandler: AppendHandler? = nil,
        extendHandler: ExtendHandler? = nil,
        insertHandler: InsertHandler? = nil,
        replaceHandler: ReplaceHandler? = nil,
        removeElementHandler: RemoveElementHandler? = nil,
        replaceAllHandler: ReplaceAllHandler? = nil,
        removeAllHandler: RemoveAllHandler? = nil
        ) -> SignalProducer<Operation<U.Payload>, NoError> {
        
            return viewmodel.collectionDataSource.producer
                .logLifeCycle(LogContext.Misc, signalName: "SingleSectionInfiniteTableViewManager viewmodel.collectionDataSource.producer")
                .on(
                    next: { [weak self] operation in
                        if let this = self {
                            switch operation {
                            case let .Initiate(values):
                                if values.count != this.tableView.numberOfRowsInSection(targetedSection) {
                                    this.tableView.reloadData()
                                }
                            case let .Append(value):
                                if let appendHandler = appendHandler {
                                    appendHandler(value: value)
                                }
                                else {
                                    if this.isFirstLoad {
                                        this.tableView.reloadData()
                                        this.isFirstLoad = false
                                    }
                                    else {
                                        let rows = this.tableView.numberOfRowsInSection(targetedSection)
                                        this.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows, inSection: targetedSection)], withRowAnimation: UITableViewRowAnimation.None)
                                    }
                                }
                            case let .AppendContentsOf(values):
                                if let extendHandler = extendHandler {
                                    extendHandler(values: values)
                                }
                                else {
                                    if this.isFirstLoad {
                                        this.tableView.reloadData()
                                        this.isFirstLoad = false
                                    }
                                    else {
                                        var rows = this.tableView.numberOfRowsInSection(targetedSection)
                                        this.tableView.insertRowsAtIndexPaths(values.map { viewmodel in NSIndexPath(forRow: rows++, inSection: targetedSection) }, withRowAnimation: UITableViewRowAnimation.None)
                                    }
                                }
                            case let .Insert(value, index):
                                if let insertHandler = insertHandler {
                                    insertHandler(value: value, index: index)
                                }
                                else {
                                    this.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: targetedSection)], withRowAnimation: UITableViewRowAnimation.None)
                                }
                            case let .Replace(value, index):
                                if let replaceHandler = replaceHandler {
                                    replaceHandler(value: value, index: index)
                                }
                                else {
                                    this.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: targetedSection)], withRowAnimation: UITableViewRowAnimation.None)
                                }
                            case let .RemoveElement(atIndex):
                                if let removeElementHandler = removeElementHandler {
                                    removeElementHandler(index: atIndex)
                                }
                                else {
                                    this.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: atIndex, inSection: targetedSection)], withRowAnimation: UITableViewRowAnimation.None)
                                }
                            case let .ReplaceAll(values):
                                if let replaceAllHandler = replaceAllHandler {
                                    replaceAllHandler(values: values)
                                }
                                else {
                                    this.tableView.reloadData()
                                }
                            case let .RemoveAll(keepCapacity):
                                if let removeAllHandler = removeAllHandler {
                                    removeAllHandler(keepCapacity: keepCapacity)
                                }
                                else {
                                    let rows = this.tableView.numberOfRowsInSection(targetedSection)
                                    var paths = [NSIndexPath]()
                                    for i in 0...rows {
                                        paths.append(NSIndexPath(forRow: i, inSection: targetedSection))
                                    }
                                    this.tableView.deleteRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.None)
                                }
                            }
                        }
                    }
                )
    }
    
    /**
    Predictive scroll.
    
    - parameter velocity:            The velocity of the scroll view (in points) at the moment the touch was released.
    - parameter targetContentOffset: The expected offset when the scrolling action decelerates to a stop.
    */
    public func predictivelyScroll(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        predictiveScrolling(tableView, withVelocity: velocity, targetContentOffset: targetContentOffset, predictiveScrollable: viewmodel)
    }
    
    /**
    Must call this function before the view controller is about to end its life cycle.
    */
    public func cleanUp() {
        infinityScrollConductor.removeInfinityScroll()
        pullToRefreshConductor.removePullToRefresh()
    }
    
    deinit {
        MiscLogVerbose("SingleSectionInfiniteTableViewManager deinitializes.")
    }
}