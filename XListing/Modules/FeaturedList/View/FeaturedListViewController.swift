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
    public var refreshControl: UIRefreshControl!
    
    // MARK: Actions
    private var nearbyButtonAction: CocoaAction!
    private var profileButtonAction: CocoaAction!
    
    // MARK: - Private variables
    private var viewmodel: IFeaturedListViewModel!
    private var bindingHelper: TableViewBindingHelper<FeaturedBusinessViewModel>!
    
    // MARK: - Setup Code
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Set up pull to refresh
        setUpRefresh()
        
        // Setup nearbyButton
        setupNearbyButton()
        // Setup profileButton
        setupProfileButton()
        
        bindingHelper = TableViewBindingHelper(tableView: tableView, sourceSignal: viewmodel.featuredBusinessViewModelArr.producer, identifier: CellIdentifier, selectionCommand: nil)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewDidAppear(animated: Bool) {
        viewmodel.presentAccountModule()
    }
    
    public func bindToViewModel(viewmodel: IFeaturedListViewModel) {
        self.viewmodel = viewmodel
    }
    
    private func setUpRefresh() {
        var refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "reorderTable", forControlEvents:UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Reordering Listings")

        self.refreshControl = refreshControl
        
    }
    
    public func reorderTable (){
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    private func shuffle(array: NSMutableArray){
        let c = array.count
        
        if (c > 0){
            for i in 0..<(c - 1) {
                let j = Int(arc4random_uniform(UInt32(c - i))) + i
                swap(&array[i], &array[j])
            }
        }
        return
    }
    
    /**
    React to Nearby Button and present NearbyViewController.
    */
    private func setupNearbyButton() {
        let pushNearby = Action<Void, Void, NoError> {
            return SignalProducer<Void, NoError> { sink, disposable in
                self.viewmodel.pushNearbyModule()
                sendCompleted(sink)
            }
        }
        
        nearbyButtonAction = CocoaAction(pushNearby, input: ())
        
        nearbyButton.target = nearbyButtonAction
        nearbyButton.action = CocoaAction.selector
    }

    /**
    React to Profile Button and present ProfileViewController.
    */
    private func setupProfileButton() {
        let pushProfile = Action<Void, Void, NoError> {
            return SignalProducer<Void, NoError> { sink, disposable in
                self.viewmodel.pushProfileModule()
                sendCompleted(sink)
            }
        }
        
        profileButtonAction = CocoaAction(pushProfile, input: ())
        
        profileButton.target = profileButtonAction
        profileButton.action = CocoaAction.selector
    }
}