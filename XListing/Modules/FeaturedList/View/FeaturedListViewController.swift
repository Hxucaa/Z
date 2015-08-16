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

private let CellIdentifier = "Cell"

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
        *  Setup Pull to Refresh
        */
        tableView.ins_addPullToRefreshWithHeight(60.0) { [weak self] scrollView -> Void in
            if let this = self {
                this.viewmodel.getFeaturedBusinesses()
                    |> map { _ -> Void in }
                    |> start(next: { _ in
                        scrollView.ins_endPullToRefresh()
                    })
            }
        }
        
        let pullToRefresh = PullToRefresh(frame: CGRectMake(0, 30, 24, 24))
        tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
        tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)
        
        /**
        Setup bottom scroll refresh
        */
        tableView.ins_addInfinityScrollWithHeight(60.0) { [weak self] scrollView -> Void in
            if let this = self {
                this.viewmodel.getFeaturedBusinesses()
                    |> map { _ -> Void in }
                    |> start(next: { _ in
                        scrollView.ins_endInfinityScrollWithStoppingContentOffset(true)
                    })
            }
        }
        
        let infinityIndicator = INSDefaultInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        tableView.ins_infiniteScrollBackgroundView.addSubview(infinityIndicator)
        infinityIndicator.startAnimating()
        
        tableView.ins_infiniteScrollBackgroundView.preserveContentInset = false
        
        
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

extension FeaturedListViewController : UITableViewDataSource, UITableViewDelegate {
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