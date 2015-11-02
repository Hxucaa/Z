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
private let CellHeightToScreenWidthRatio = 0.565
private let CellRowHeight = round(UIScreen.mainScreen().bounds.width * CGFloat(CellHeightToScreenWidthRatio))

/**
How is Infinite Scrolling implemented?

The `INSPullToRefresh` is used to assist in the implementation of Infinite Scrolling. The library allows to customize Pull To Refresh and Infinity Scroll.

Install the pull to refresh view like so `tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)`. Add action to pull to refresh via `tableView.ins_addPullToRefreshWithHeight`. Install infinity scroll view like so `tableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)`. Add action to infinity scroll via `tableView.ins_addInfinityScrollWithHeight`.

We also detect when user scrolls pass a certain point, fetch more data from remote so that user don't have to scroll to the bottom of the table view to trigger fetching. This improves user experience.
*/

public final class FeaturedListViewController: XUIViewController {

    // MARK: - UI Controls
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        // makes the gap between table view and navigation bar go away
        tableView.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        // makes the gap at the bottom of the table view go away
        tableView.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        
        tableView.separatorStyle = .None
        tableView.dataSource = self
        
        // set cell height based on devices
        tableView.rowHeight = round(UIScreen.mainScreen().bounds.width * CGFloat(CellHeightToScreenWidthRatio))
        
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
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        navigationController?.navigationBar.barTintColor = UIColor.x_PrimaryColor()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        view.opaque = true
        view.backgroundColor = UIColor.x_FeaturedTableBG()
        
        singleSectionInfiniteTableViewManager = SingleSectionInfiniteTableViewManager(tableView: tableView, viewmodel: self.viewmodel as! FeaturedListViewModel)
        
        view.addSubview(tableView)
        
        constrain(tableView) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewmodel.fetchMoreData()
            |> start()
        
        navigationController?.navigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = true

        navigationController?.navigationBar.translucent = false
        
        compositeDisposable += singleSectionInfiniteTableViewManager.reactToDataSource(targetedSection: 0)
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Featured, "viewmodel.collectionDataSource.producer")
            |> start()
        
        willAppearTableView()
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        singleSectionInfiniteTableViewManager.cleanUp()
        compositeDisposable.dispose()
        FeaturedLogVerbose("Featured List View Controller deinitializes.")
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
                    self?.viewmodel.pushSocialBusinessModule(indexPath.row)
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
        
    }
}

extension FeaturedListViewController : UITableViewDataSource, UITableViewDelegate {
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    - parameter tableView: The table-view object requesting this information.
    - parameter section:   An index number identifying a section in tableView.
    
    - returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.collectionDataSource.count
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    - parameter tableView: A table-view object requesting the cell.
    - parameter indexPath: An index path locating a row in tableView.
    
    - returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? FeaturedListBusinessTableViewCell ?? FeaturedListBusinessTableViewCell(estimatedFrame: CGRectMake(0, 0, tableView.frame.width, CellRowHeight), style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        
        cell.bindViewModel(viewmodel.collectionDataSource.array[indexPath.row])
        return cell
    }
}

extension FeaturedListViewController : UIScrollViewDelegate {
    
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