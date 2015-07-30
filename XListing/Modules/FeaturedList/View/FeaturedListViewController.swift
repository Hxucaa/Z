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

private let CellIdentifier = "Cell"

public final class FeaturedListViewController: XUIViewController {

    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nearbyButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    private let refreshControl = UIRefreshControl()
    
    // MARK: Properties
    private var viewmodel: IFeaturedListViewModel!
    private let compositeDisposable = CompositeDisposable()
    private var isLoading = 0
    
    // MARK: Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupRefresh()
        setupNearbyButton()
        setupProfileButton()
        setupTableView()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        compositeDisposable.dispose()
        NearbyLogVerbose("Featured List View Controller deinitializes.")
    }
    
    private func setupTableView() {
        
        compositeDisposable += viewmodel.featuredBusinessViewModelArr.producer
            |> start(next: { [weak self] _ in
                self?.tableView.reloadData()
            })
        
        tableView.dataSource = self
    }
    
    private func setupRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "刷新中")
        
        let refresh = Action<UIRefreshControl, Void, NSError> { refreshControl in
            return self.viewmodel.getFeaturedBusinesses()
                |> map { _ -> Void in }
                |> on(next: { [weak self] _ in
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                })
        }
        
        refreshControl.addTarget(refresh.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .ValueChanged)
        
        tableView.addSubview(refreshControl)
        
        // turn off autoresizing mask off to allow custom autolayout constraints
        refreshControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // add constraints
        view.addConstraints(
            [
                // center X alignment
                NSLayoutConstraint(
                    item: refreshControl,
                    attribute: NSLayoutAttribute.CenterX,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: view,
                    attribute: NSLayoutAttribute.CenterX,
                    multiplier: 1.0,
                    constant: 0.0
                ),
                // top space to topLayoutGuide is 90
                NSLayoutConstraint(
                    item: refreshControl,
                    attribute: NSLayoutAttribute.Top,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: topLayoutGuide,
                    attribute: NSLayoutAttribute.Top,
                    multiplier: 1.0,
                    constant: 90.0
                ),
                // width set to 150
                NSLayoutConstraint(
                    item: refreshControl,
                    attribute: NSLayoutAttribute.Width,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: 150.0
                )
            ]
        )
    }
    
    /**
    React to Nearby Button and present NearbyViewController.
    */
    private func setupNearbyButton() {
        let pushNearby = Action<UIBarButtonItem, Void, NoError> { [weak self] button in
            return SignalProducer<Void, NoError> { [weak self] sink, disposable in
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
        
        willAppearTableView()
    }
    
    private func willAppearTableView() {
        
        // create a signal associated with `tableView:didSelectRowAtIndexPath:` form delegate `UITableViewDelegate`
        // when the specified row is now selected
        compositeDisposable += rac_signalForSelector(Selector("tableView:didSelectRowAtIndexPath:"), fromProtocol: UITableViewDelegate.self).toSignalProducer()
            // forwards events from producer until the view controller is going to disappear
            |> takeUntil(
                rac_signalForSelector(viewWillDisappearSelector).toSignalProducer()
                    |> toNihil
            )
            |> map { ($0 as! RACTuple).second as! NSIndexPath }
            |> start(
                next: { [weak self] indexPath in
                    let something = indexPath.row
                    self?.viewmodel.pushDetailModule(indexPath.row)
                },
                completed: {
                    FeaturedLogVerbose("`tableView:didSelectRowAtIndexPath:` signal completes.")
                }
        )
        
        rac_signalForSelector(Selector("scrollViewDidEndDragging:willDecelerate:"),
            fromProtocol: UIScrollViewDelegate.self).toSignalProducer()
            |> takeUntil(
                rac_signalForSelector(viewWillDisappearSelector).toSignalProducer()
                    |> toNihil
            )
            |> map { ($0 as! RACTuple).first as! UIScrollView }
            |> start(
                next: { scrollView in
                    if (self.isLoading != 0) {
                        return
                    }
                    
                    self.isLoading = 1
                    
                    if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height * 2)) {
                        // reached bottom of table view
                        self.viewmodel.getFeaturedBusinesses()
                            |> map { _ -> Void in }
                            |> start(next: { [weak self] _ in
                                self?.isLoading = 0
                            })

                        println("Add more rows")
                    }
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