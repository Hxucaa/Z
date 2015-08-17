//
//  ViewController.swift
//  XListing
//
//  Created by Lance on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import SDWebImage
import ReactiveCocoa
import INSPullToRefresh
import Dollar

private let CellIdentifier = "Cell"
private let PullToRefreshHeight: CGFloat = 60.0
private let InfinityScrollHeight: CGFloat = 60.0

/**
How is Infinite Scrolling implemented?

The `INSPullToRefresh` is used to assist in the implementation of Infinite Scrolling. The library allows to customize Pull To Refresh and Infinity Scroll.

Install the pull to refresh view like so `tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)`. Add action to pull to refresh via `tableView.ins_addPullToRefreshWithHeight`. Install infinity scroll view like so `tableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)`. Add action to infinity scroll via `tableView.ins_addInfinityScrollWithHeight`.

We also detect when user scrolls pass a certain point, fetch more data from remote so that user don't have to scroll to the bottom of the table view to trigger fetching. This improves user experience.
*/

public final class FeaturedListViewController: XUIViewController {

    // MARK: - UI
    // MARK: Controls
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var nearbyButton: UIBarButtonItem!
    @IBOutlet private weak var profileButton: UIBarButtonItem!
    private let refreshControl = UIRefreshControl()
    
    // MARK: Properties
    private var viewmodel: IFeaturedListViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupNearbyButton()
        setupProfileButton()
        
        /**
        *  Setup the action to Pull to Refresh
        */
        tableView.ins_addPullToRefreshWithHeight(PullToRefreshHeight) { [weak self] scrollView -> Void in
            // When pull to refresh is triggered, fetch more data if not already happening
            if let this = self {
                let startTime = NSDate.timeIntervalSinceReferenceDate()
                this.viewmodel.getFeaturedBusinesses()
                    |> on(next: { _ in
                        FeaturedLogVerbose("Pull to refresh fetched additional data for infinite scrolling.")
                    })
                    |> map { _ -> Void in }
                    |> flatMap(.Merge) { _ -> SignalProducer<Void, NSError> in
                        
                        /**
                        *  Ensure the pull to refresh is displayed for a minimum amount of time even if network request is very fast.
                        */
                        let currentTime = NSDate.timeIntervalSinceReferenceDate()
                        let elapsedTime = currentTime - startTime
                        
                        if elapsedTime <= Constants.PULL_TO_REFRESH_DELAY {
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
                        completed: {
                            scrollView.ins_endPullToRefresh()
                        }
                    )
            }
        }
        
        /**
        *  Setup the view to Pull to Refresh
        */
        let pullToRefresh = PullToRefresh(frame: CGRectMake(0, 30, 24, 24))
        tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
        tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)
        
        /**
        *  Setup the action to infinity scroll at the bottom
        */
        tableView.ins_addInfinityScrollWithHeight(InfinityScrollHeight) { [weak self] scrollView -> Void in
            // When infinity scroll is triggered, fetch more data if not already happening
            if let this = self {
                this.viewmodel.getFeaturedBusinesses()
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
        
        
        tableView.dataSource = self
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        tableView.ins_removeInfinityScroll()
        tableView.ins_removePullToRefresh()
        compositeDisposable.dispose()
        FeaturedLogVerbose("Featured List View Controller deinitializes.")
    }
    
    /**
    React to Nearby Button and present NearbyViewController.
    */
    private func setupNearbyButton() {
        let pushNearby = Action<UIBarButtonItem, Void, NoError> { [weak self] button in
            return SignalProducer<Void, NoError> { [weak self] sink, disposable in
                
                self?.nearbyButton.enabled = false
                
                self?.viewmodel.pushNearbyModule()
                sendCompleted(sink)
            }
        }
        
        nearbyButton.target = pushNearby.unsafeCocoaAction
        nearbyButton.action = CocoaAction.selector
    }

    /**
    React to Profile Button and present ProfileViewController.
    */
    private func setupProfileButton() {
        let pushProfile = Action<UIBarButtonItem, Void, NoError> { [weak self] button in
            return SignalProducer<Void, NoError> { [weak self] sink, disposable in
                self?.viewmodel.pushProfileModule()
                sendCompleted(sink)
            }
        }
        profileButton.target = pushProfile.unsafeCocoaAction
        profileButton.action = CocoaAction.selector
    }
    
    // MARK: Will Appear
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false // for navigation bar hide
        UIApplication.sharedApplication().statusBarHidden = false
        
        nearbyButton.enabled = true
        
        willAppearTableView()
    }
    
    private func willAppearTableView() {
        
        // create a signal associated with `tableView:didSelectRowAtIndexPath:` form delegate `UITableViewDelegate`
        // when the specified row is now selected
        compositeDisposable += rac_signalForSelector(Selector("tableView:didSelectRowAtIndexPath:"), fromProtocol: UITableViewDelegate.self).toSignalProducer()
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> map { ($0 as! RACTuple).second as! NSIndexPath }
            |> logLifeCycle(LogContext.Featured, "tableView:didSelectRowAtIndexPath:")
            |> start(
                next: { [weak self] indexPath in
                    let something = indexPath.row
                    self?.viewmodel.pushDetailModule(indexPath.row)
                }
            )
        
        compositeDisposable += viewmodel.featuredBusinessViewModelArr.producer
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Featured, "viewmodel.featuredBusinessViewModelArr.producer")
            |> start(
                next: { [weak self] _ in
                    self?.tableView.reloadData()
                }
            )
        
        /// Triggered when scrolling is done
//        rac_signalForSelector(Selector("scrollViewWillEndDragging:withVelocity:targetContentOffset:"), fromProtocol: UIScrollViewDelegate.self).toSignalProducer()
//            |> takeUntilViewWillDisappear(self)
//            |> map { parameters -> (UIScrollView, CGPoint) in
//                let tuple = parameters as! RACTuple
//                return (tuple.first as! UIScrollView, (tuple.second as! NSValue).CGPointValue())
//            }
//            |> start(
//                next: { [weak self] scrollView, velocity in
//                    if let this = self,
//                        tableView = self?.tableView
//                        // make sure the scrollView instance returned by the signal is the same instance as tha tableView in this class.
//                        where tableView === scrollView &&
//                            // table view is being scrolled down, not up
//                            velocity.y > 0.0 &&
//                            /// Only fetch more data if both pull to refresh and infinity scroll are not already triggered. We don't want to trigger network request repeatedly.
//                            tableView.ins_pullToRefreshBackgroundView.state != INSPullToRefreshBackgroundViewState.Triggered &&
//                            tableView.ins_infiniteScrollBackgroundView.state != INSInfiniteScrollBackgroundViewState.Loading {
//                                
//                        // get the indexpath of currently visible cells and map the array to indexPath.row
//                        if let rows = tableView.indexPathsForVisibleRows()?.map({ $0.row ?? 0 }),
//                            // then find the largest row
//                            max = $.max(rows)
//                            // if there isn't enough data to be displayed, fetch more data
//                            where !this.viewmodel.havePlentyOfData(max) {
//                            
//                            this.viewmodel.getFeaturedBusinesses()
//                                |> on(next: { _ in
//                                    FeaturedLogVerbose("TableView `scrollViewDidEndDragging:willDecelerate:` fetched additional data for infinite scrolling.")
//                                })
//                                |> start()
//                        }
//                    }
//                }
//            )
        
        /**
        Assigning UITableView delegate has to happen after signals are established.
        
        - tableView.delegate is assigned to self somewhere in UITableViewController designated initializer
        
        - UITableView caches presence of optional delegate methods to avoid -respondsToSelector: calls
        
        - You use -rac_signalForSelector:fromProtocol: and RAC creates method implementation for you in runtime. But UITableView knows nothing about this implementation, it still thinks that there's no such method
        
        The solution is to reassign delegate after all your -rac_signalForSelector:fromProtocol: calls:
        */
        tableView.delegate = self
    }
    
    // MARK: Bindings
    
    
    public func bindToViewModel(viewmodel: IFeaturedListViewModel) {
        self.viewmodel = viewmodel
    }
}

extension FeaturedListViewController : UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.featuredBusinessViewModelArr.value.count
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! FeaturedListBusinessTableViewCell
        cell.bindViewModel(viewmodel.featuredBusinessViewModelArr.value[indexPath.row])
        
        return cell
    }
}

extension FeaturedListViewController : UIScrollViewDelegate {
    /**
    Tells the delegate when the user finishes scrolling the content.
    
    :param: scrollView          The scroll-view object where the user ended the touch..
    :param: velocity            The velocity of the scroll view (in points) at the moment the touch was released.
    :param: targetContentOffset The expected offset when the scrolling action decelerates to a stop.
    */
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // make sure the scrollView instance is the same instance as tha tableView in this class.
        if tableView === scrollView &&
            // table view is being scrolled down, not up
            velocity.y > 0.0 &&
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
                
                if let row = indexPath?.row where !viewmodel.havePlentyOfData(row) {
                    viewmodel.getFeaturedBusinesses()
                        |> on(next: { _ in
                            FeaturedLogVerbose("TableView `scrollViewDidEndDragging:willDecelerate:` fetched additional data for infinite scrolling.")
                        })
                        |> start()
                }
        }
    }
    
//    public func scrollViewDidScroll(scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < -145.0 {
//            scrollView.contentOffset = CGPoint(x: 0.0, y: -145.0)
//        }
//    }
}