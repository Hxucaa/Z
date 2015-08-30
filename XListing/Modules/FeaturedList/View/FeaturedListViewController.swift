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
import Dollar
import Cartography

private let CellIdentifier = "Cell"

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
    private var singleSectionInfiniteTableViewManager: SingleSectionInfiniteTableViewManager<UITableView, FeaturedListViewModel>!
    private let statusBarBackgroundView = StatusBarBackgroundView()
    
    // MARK: - Properties
    private var viewmodel: IFeaturedListViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        // makes the gap between table view and navigation bar go away
        tableView.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        // makes the gap at the bottom of the table view go away
        tableView.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        
        setupNearbyButton()
        setupProfileButton()
        
        singleSectionInfiniteTableViewManager = SingleSectionInfiniteTableViewManager(tableView: self.tableView, viewmodel: self.viewmodel as! FeaturedListViewModel)

        tableView.dataSource = self
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = true
        
        // add statusBarBackgroundView to navigationController
        navigationController?.view.addSubview(statusBarBackgroundView)
        navigationController?.navigationBar.translucent = false
        
        compositeDisposable += singleSectionInfiniteTableViewManager.reactToDataSource()
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Featured, "viewmodel.collectionDataSource.producer")
            |> start()
        
        willAppearTableView()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        statusBarBackgroundView.removeFromSuperview()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        nearbyButton.enabled = true
    }
    
    deinit {
        singleSectionInfiniteTableViewManager.cleanUp()
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
        
        /**
        Assigning UITableView delegate has to happen after signals are established.
        
        - tableView.delegate is assigned to self somewhere in UITableViewController designated initializer
        
        - UITableView caches presence of optional delegate methods to avoid -respondsToSelector: calls
        
        - You use -rac_signalForSelector:fromProtocol: and RAC creates method implementation for you in runtime. But UITableView knows nothing about this implementation, it still thinks that there's no such method
        
        The solution is to reassign delegate after all your -rac_signalForSelector:fromProtocol: calls:
        */
        tableView.delegate = nil
        tableView.delegate = self
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IFeaturedListViewModel) {
        self.viewmodel = viewmodel
        
        self.viewmodel.fetchMoreData()
            |> start()
    }
}

extension FeaturedListViewController : UITableViewDataSource, UITableViewDelegate {
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.collectionDataSource.count
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! FeaturedListBusinessTableViewCell
        cell.bindViewModel(viewmodel.collectionDataSource.array[indexPath.row])
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
        if tableView === scrollView {
            predictiveScrolling(tableView, withVelocity: velocity, targetContentOffset: targetContentOffset, predictiveScrollable: viewmodel as! FeaturedListViewModel)
        }
    }
}