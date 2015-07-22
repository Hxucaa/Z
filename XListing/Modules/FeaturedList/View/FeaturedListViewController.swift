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
    
    // MARK: - Private variables
    private var viewmodel: IFeaturedListViewModel!
    
    // MARK: - Setup Code
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupRefresh()
        setupNearbyButton()
        setupProfileButton()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewDidAppear(animated: Bool) {
        setupTableView()
    }
    
    public func bindToViewModel(viewmodel: IFeaturedListViewModel) {
        self.viewmodel = viewmodel
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        self.viewmodel.featuredBusinessViewModelArr.producer
            |> start(next: { [weak self] _ in
                self?.tableView.reloadData()
            })
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
        
        self.tableView.addSubview(refreshControl)
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
    
    /**
    Tells the delegate that the specified row is now selected.
    
    :param: tableView A table-view object informing the delegate about the new row selection.
    :param: indexPath An index path locating the new selected row in tableView.
    */
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.viewmodel.pushDetailModule(indexPath.row)
    }
}