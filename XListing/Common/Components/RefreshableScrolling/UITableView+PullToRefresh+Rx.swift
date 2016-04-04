//
//  UITableView+PullToRefresh+Rx.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import INSPullToRefresh
import RxSwift
import RxCocoa
import RxDataSources

private let PullToRefreshHeight: CGFloat = 60.0

public typealias RefreshTrigger = Driver<Void>

private struct AssociationKey {
    static var refreshTrigger: UInt8 = 18
}

private func lazyPublishSubject<T>(host: AnyObject, key: UnsafePointer<Void>) -> PublishSubject<T> {
    return lazyAssociatedProperty(host, key: key) {
        let property = PublishSubject<T>()
        return property
    }
}

extension UITableView {
    public func enablePullToRefresh(height: CGFloat = PullToRefreshHeight) {
        ins_addPullToRefreshWithHeight(PullToRefreshHeight) { [unowned self] scrollView -> Void in
            
            self.rx_refreshTrigger.onNext(())
        }
        
        /**
         *  Setup the view to Pull to Refresh
         */
        let pullToRefresh = PullToRefresh(frame: CGRectMake(0, 0, 24, 24))
        ins_pullToRefreshBackgroundView.delegate = pullToRefresh
        ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)
    }
    
    public func endRefresh() {
        ins_endPullToRefresh()
    }
    
    public func removePullToRefresh() {
        ins_removePullToRefresh()
    }
}


extension UITableView {
    
    /// Notification of pull to refresh being triggered.
    public var rx_refreshTrigger: PublishSubject<Void> {
        return lazyPublishSubject(self, key: &AssociationKey.refreshTrigger)
    }
    
    /// Inform pull to refresh to stop the animation.
    public var rx_endRefresh: AnyObserver<Void> {
        return UIBindingObserver(UIElement: self) {
            $0.0.ins_endPullToRefresh()
        }.asObserver()
    }
}

extension UITableView {
    
    /// Prepends a notification to `startRefresh`.
    /// This is used to start an initial load as soon as the page is loaded.
    public var rx_startWithRefreshTrigger: Driver<Void> {
        return rx_refreshTrigger
            .asDriver(onErrorJustReturn: ())
            // initial load of data as view controller is being displayed
            .startWith(())
    }
}

/// A data source that implement pull to refresh in addition to reload.
public class RxTableViewSectionedRefreshAndReloadDataSource<S: SectionModelType> : RxTableViewSectionedReloadDataSource<S> {
    
    public typealias Element = [S]
    
    public override func tableView(tableView: UITableView, observedEvent: RxSwift.Event<Element>) {
        UIBindingObserver(UIElement: self) { dataSource, element in
            assert(tableView.ins_pullToRefreshBackgroundView.delegate != nil, "You must enable Pull To Refresh on table view by calling `enablePullToRefresh`, before it is being reloaded.")
            dataSource.setSections(element)
            tableView.reloadData()
            tableView.ins_endPullToRefresh()
        }.on(observedEvent)
    }
}
