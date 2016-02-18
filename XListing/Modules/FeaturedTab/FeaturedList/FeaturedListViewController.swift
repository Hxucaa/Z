//
//  ViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Dollar
import Cartography
import AMScrollingNavbar
import AsyncDisplayKit

/**
How is Infinite Scrolling implemented?

The `INSPullToRefresh` is used to assist in the implementation of Infinite Scrolling. The library allows to customize Pull To Refresh and Infinity Scroll.

Install the pull to refresh view like so `tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)`. Add action to pull to refresh via `tableView.ins_addPullToRefreshWithHeight`. Install infinity scroll view like so `tableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)`. Add action to infinity scroll via `tableView.ins_addInfinityScrollWithHeight`.

We also detect when user scrolls pass a certain point, fetch more data from remote so that user don't have to scroll to the bottom of the table view to trigger fetching. This improves user experience.
*/

public final class FeaturedListViewController: XScrollingNavigationViewController {
    
    // MARK: - UI Controls
    private lazy var tableView: ASTableView = {
        let tableView = ASTableView(frame: self.view.bounds, style: UITableViewStyle.Grouped, asyncDataFetching: true)
        
        // makes the gap between table view and navigation bar go away
        tableView.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        // makes the gap at the bottom of the table view go away
        tableView.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        
        tableView.separatorStyle = .None
        tableView.asyncDataSource = self
        
        return tableView
    }()
    
    private var singleSectionInfiniteTableViewManager: SingleSectionInfiniteTableViewManager<UITableView, FeaturedListViewModel>!
    
    // MARK: - Properties
    private var viewmodel: IFeaturedListViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "推荐"
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.x_PrimaryColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        view.opaque = true
        view.backgroundColor = UIColor.x_FeaturedTableBG()
        
        view.addSubview(tableView)
        
        singleSectionInfiniteTableViewManager = SingleSectionInfiniteTableViewManager(tableView: tableView, viewmodel: self.viewmodel as! FeaturedListViewModel)
    }
    
    public override func viewWillLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Use followScrollView(_: delay:) to start following the scrolling of a scrollable view (e.g.: a UIScrollView or UITableView).
        let navigationController = self.navigationController as? ScrollingNavigationController
        navigationController?.followScrollView(tableView, delay: 50.0)

        // You can set a delegate to receive a call when the state of the navigation bar changes:
        navigationController?.scrollingNavbarDelegate = self


        viewmodel.fetchMoreData()
            .start()


        compositeDisposable += singleSectionInfiniteTableViewManager.reactToDataSource(targetedSection: 0)
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Featured, signalName: "viewmodel.collectionDataSource.producer")
            .start()



        // create a signal associated with `tableView:didSelectRowAtIndexPath:` form delegate `UITableViewDelegate`
        // when the specified row is now selected
        compositeDisposable += rac_signalForSelector(Selector("tableView:didSelectRowAtIndexPath:"), fromProtocol: UITableViewDelegate.self).toSignalProducer()
            // forwards events from producer until the view controller is going to disappear
            .takeUntilViewWillDisappear(self)
            .map { ($0 as! RACTuple).second as! NSIndexPath }
            .logLifeCycle(LogContext.Featured, signalName: "tableView:didSelectRowAtIndexPath:")
            .startWithNext { [weak self] indexPath in
                self?.viewmodel.pushSocialBusinessModule(indexPath.row)
        }
        
        /**
        Assigning UITableView delegate has to happen after signals are established.
        
        - tableView.delegate is assigned to self somewhere in UITableViewController designated initializer
        
        - UITableView caches presence of optional delegate methods to avoid -respondsToSelector: calls
        
        - You use -rac_signalForSelector:fromProtocol: and RAC creates method implementation for you in runtime. But UITableView knows nothing about this implementation, it still thinks that there's no such method
        
        The solution is to reassign delegate after all your -rac_signalForSelector:fromProtocol: calls:
        */
        tableView.asyncDelegate = nil
        tableView.asyncDelegate = self
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        (self.navigationController as? ScrollingNavigationController)?.showNavbar(animated: true)
    }
    
    deinit {
        singleSectionInfiniteTableViewManager.cleanUp()
        compositeDisposable.dispose()
        FeaturedLogVerbose("Featured List View Controller deinitializes.")
    }
    
    // MARK: - Bindings

    public func bindToViewModel(viewmodel: IFeaturedListViewModel) {
        self.viewmodel = viewmodel
        
    }
}

extension FeaturedListViewController : ASTableViewDataSource, ASTableViewDelegate {
    /**
     Tells the data source to return the number of rows in a given section of a table view. (required)
     
     - parameter tableView: The table-view object requesting this information.
     - parameter section:   An index number identifying a section in tableView.
     
     - returns: The number of rows in section.
     */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.collectionDataSource.count
    }
    
    public func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        let cell = FeaturedListCellNode(viewmodel: viewmodel.collectionDataSource.array[indexPath.row])
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension FeaturedListViewController {
    
    /**
     Tells the delegate when the user finishes scrolling the content.
     
     - parameter scrollView:          The scroll-view object where the user ended the touch..
     - parameter velocity:            The velocity of the scroll view (in points) at the moment the touch was released.
     - parameter targetContentOffset: The expected offset when the scrolling action decelerates to a stop.
     */
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // make sure the scrollView instance is the same instance as tha tableView in this class.
        if tableView === scrollView {
            predictiveScrolling(tableView, withVelocity: velocity, targetContentOffset: targetContentOffset, predictiveScrollable: viewmodel as! FeaturedListViewModel)
        }
    }
}

extension FeaturedListViewController : ScrollingNavigationControllerDelegate {
    
    /**
     When the user taps the status bar, by default a scrollable view scrolls to the top of its content. If you want to also show the navigation bar, make sure to include this in your controller
     */
    public override func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        (self.navigationController as? ScrollingNavigationController)?.showNavbar(animated: true)
        return true
    }
}
