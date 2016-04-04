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

private let PullToRefreshHeight: CGFloat = 60.0

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
            
            self.rx_startRefresh.onNext(())
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
    public var rx_startRefresh: PublishSubject<Void> {
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
    public var rx_startWithRefresh: Driver<Void> {
        return rx_startRefresh
            .asDriver(onErrorJustReturn: ())
            // initial load of data as view controller is being displayed
            .startWith(())
    }
}
