//
//  ViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import Dollar
import Cartography
import AMScrollingNavbar
import AsyncDisplayKit


//import INSPullToRefresh
//
//private let PullToRefreshHeight: CGFloat = 60.0
//
//public class PTR<T: UITableView, U: IPullToRefreshDataSource> {
//    
//    private weak var tableView: T!
//    private weak var pullToRefreshable: U!
//    
//    public init(tableView: T, pullToRefreshable: U) {
//        self.tableView = tableView
//        self.pullToRefreshable = pullToRefreshable
//        
//        /**
//         *  Setup the view to Pull to Refresh
//         */
//        let pullToRefresh = PullToRefresh(frame: CGRectMake(0, 0, 24, 24))
//        tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
//        tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)
//        
//        
//        /**
//        *  Setup the action to Pull to Refresh
//        */
//        tableView.ins_addPullToRefreshWithHeight(PullToRefreshHeight) { [weak self] scrollView -> Void in
//            // When pull to refresh is triggered, fetch more data if not already happening
//            if let this = self {
//                let startTime = NSDate.timeIntervalSinceReferenceDate()
//                this.pullToRefreshable.refreshData()
//                    .on(next: { _ in
//                        MiscLogVerbose("Pull to refresh fetched additional data for infinite scrolling.")
//                    })
//                    .flatMap(.Merge) { _ -> SignalProducer<Void, NSError> in
//                        
//                        /**
//                         *  Ensure the pull to refresh is displayed for a minimum amount of time even if network request is very fast.
//                         */
//                        let currentTime = NSDate.timeIntervalSinceReferenceDate()
//                        let elapsedTime = currentTime - startTime
//                        
//                        if elapsedTime < Constants.PULL_TO_REFRESH_DELAY {
//                            return SignalProducer<Void, NSError>.empty
//                                // delay the signal due to the animation of retracting keyboard
//                                // this cannot be executed on main thread, otherwise UI will be blocked
//                                .delay(Constants.PULL_TO_REFRESH_DELAY - elapsedTime, onScheduler: QueueScheduler())
//                                // return the signal to main/ui thread in order to run UI related code
//                                .observeOn(UIScheduler())
//                        }
//                        else {
//                            return SignalProducer<Void, NSError>.empty
//                        }
//                    }
//                    .start { event in
//                        switch event {
//                        case .Failed(let error):
//                            scrollView.ins_endPullToRefresh()
//                            MiscLogError("Pull to refresh error: \(error)")
//                        case .Completed:
//                            scrollView.ins_endPullToRefresh()
//                        default: break
//                        }
//                }
//            }
//        }
//    }
//    
//    public func removePullToRefresh() {
//        tableView.ins_removePullToRefresh()
//    }
//}

/**
How is Infinite Scrolling implemented?

The `INSPullToRefresh` is used to assist in the implementation of Infinite Scrolling. The library allows to customize Pull To Refresh and Infinity Scroll.

Install the pull to refresh view like so `tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)`. Add action to pull to refresh via `tableView.ins_addPullToRefreshWithHeight`. Install infinity scroll view like so `tableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)`. Add action to infinity scroll via `tableView.ins_addInfinityScrollWithHeight`.

We also detect when user scrolls pass a certain point, fetch more data from remote so that user don't have to scroll to the bottom of the table view to trigger fetching. This improves user experience.
*/

final class FeaturedListViewController: XScrollingNavigationViewController {
    
    typealias InputViewModel = (didSelectRow: SignalProducer<NSIndexPath, NoError>, refreshTrigger: SignalProducer<Void, NoError>, fetchMoreTrigger: SignalProducer<Void, NoError>) -> IFeaturedListViewModel
    
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
    
//    private var singleSectionInfiniteTableViewManager: SingleSectionInfiniteTableViewManager<UITableView, FeaturedListViewModel>!
    
    // MARK: - Properties
    private var inputViewModel: InputViewModel!
    private var viewmodel: IFeaturedListViewModel!
    
    // MARK: - Setups
    static let startLoadingOffset: CGFloat = 20.0
    static func isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "推荐"
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.x_PrimaryColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        view.opaque = true
        view.backgroundColor = UIColor.x_FeaturedTableBG()
        
        view.addSubview(tableView)
        
//        singleSectionInfiniteTableViewManager = SingleSectionInfiniteTableViewManager(tableView: tableView, viewmodel: self.viewmodel as! FeaturedListViewModel)
        let didSelectRowAtIndexPath = #selector(UITableViewDelegate.tableView(_:didSelectRowAtIndexPath:))
        let didSelectRow = rac_signalForSelector(didSelectRowAtIndexPath, fromProtocol: UITableViewDelegate.self).toSignalProducer()
            .noSelectorError()
            // forwards events from producer until the view controller is going to disappear
            .takeUntilViewWillDisappear(self)
            .map { ($0 as! RACTuple).second as! NSIndexPath }
            .logLifeCycle(LogContext.Featured, signalName: didSelectRowAtIndexPath.description)
        
//        let loadNextPageTrigger = DynamicProperty(object: tableView, keyPath: "contentOffset").producer
//            .ignoreNil()
//            .debug()
//            .map {
//                let p = $0 as! NSValue
//                return p.CGPointValue()
////                CGPoint(x: $0.x, y: $0.y)
//            }
        let loadNextPageTrigger = SignalProducer<CGPoint, NoError>.empty
            .debug()
            .flatMap(FlattenStrategy.Merge) { offset -> SignalProducer<Void, NoError> in
                let startLoadingOffset: CGFloat = 20.0
                if offset.y + self.tableView.frame.size.height + startLoadingOffset > self.tableView.contentSize.height {
//                    return SignalProducer<Void, NoError>(value: ())
                    return SignalProducer.empty
                }
                else {
                    
                    return SignalProducer.empty
                }
            }
        
        viewmodel = inputViewModel(didSelectRow: didSelectRow, refreshTrigger: SignalProducer<Void, NoError>.buffer(1).0, fetchMoreTrigger: loadNextPageTrigger)
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Use followScrollView(_: delay:) to start following the scrolling of a scrollable view (e.g.: a UIScrollView or UITableView).
        let navigationController = self.navigationController as? ScrollingNavigationController
        navigationController?.followScrollView(tableView, delay: 50.0)

        // You can set a delegate to receive a call when the state of the navigation bar changes:
        navigationController?.scrollingNavbarDelegate = self


//        viewmodel.fetchMoreData()
//            .start()


//        compositeDisposable += singleSectionInfiniteTableViewManager.reactToDataSource(targetedSection: 0)
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.Featured, signalName: "viewmodel.collectionDataSource.producer")
//            .start()



//        // create a signal associated with `tableView:didSelectRowAtIndexPath:` form delegate `UITableViewDelegate`
//        // when the specified row is now selected
//        compositeDisposable += rac_signalForSelector(Selector("tableView:didSelectRowAtIndexPath:"), fromProtocol: UITableViewDelegate.self).toSignalProducer()
//            .noSelectorError()
//            // forwards events from producer until the view controller is going to disappear
//            .takeUntilViewWillDisappear(self)
//            .map { ($0 as! RACTuple).second as! NSIndexPath }
//            .logLifeCycle(LogContext.Featured, signalName: "tableView:didSelectRowAtIndexPath:")
//            .startWithNext { [weak self] indexPath in
//                self?.viewmodel.pushSocialBusinessModule(indexPath.row)
//            }
        
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        (self.navigationController as? ScrollingNavigationController)?.showNavbar(animated: true)
    }
    
    deinit {
//        singleSectionInfiniteTableViewManager.cleanUp()
        FeaturedLogVerbose("Featured List View Controller deinitializes.")
    }
    
    // MARK: - Bindings

    func bindToViewModel(inputViewModel: InputViewModel) {
        self.inputViewModel = inputViewModel
    }
}

extension FeaturedListViewController : ASTableViewDataSource, ASTableViewDelegate {
    /**
     Tells the data source to return the number of rows in a given section of a table view. (required)
     
     - parameter tableView: The table-view object requesting this information.
     - parameter section:   An index number identifying a section in tableView.
     
     - returns: The number of rows in section.
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.collectionDataSource.value.count
    }
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        let cell = FeaturedListCellNode(businessInfo: viewmodel.collectionDataSource.value[indexPath.row])
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
}

//extension FeaturedListViewController {
//    
//    /**
//     Tells the delegate when the user finishes scrolling the content.
//     
//     - parameter scrollView:          The scroll-view object where the user ended the touch..
//     - parameter velocity:            The velocity of the scroll view (in points) at the moment the touch was released.
//     - parameter targetContentOffset: The expected offset when the scrolling action decelerates to a stop.
//     */
//    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        // make sure the scrollView instance is the same instance as tha tableView in this class.
//        if tableView === scrollView {
//            predictiveScrolling(tableView, withVelocity: velocity, targetContentOffset: targetContentOffset, predictiveScrollable: viewmodel as! FeaturedListViewModel)
//        }
//    }
//}

extension FeaturedListViewController : ScrollingNavigationControllerDelegate {
    
    /**
     When the user taps the status bar, by default a scrollable view scrolls to the top of its content. If you want to also show the navigation bar, make sure to include this in your controller
     */
    override func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        (self.navigationController as? ScrollingNavigationController)?.showNavbar(animated: true)
        return true
    }
}
