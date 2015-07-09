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
    private var refreshControl: UIRefreshControl!
    
    // MARK: - Private variables
    private var viewmodel: IFeaturedListViewModel!
    private var bindingHelper: ReactiveTableBindingHelper<FeaturedBusinessViewModel>!
    
    // MARK: - Setup Code
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
        viewmodel.presentAccountModule()
    }
    
    public func bindToViewModel(viewmodel: IFeaturedListViewModel) {
        self.viewmodel = viewmodel
    }
    
    private func setupTableView() {
        bindingHelper = ReactiveTableBindingHelper(
            tableView: tableView,
            sourceSignal: viewmodel.featuredBusinessViewModelArr.producer,
            storyboardIdentifier: CellIdentifier
            )
            { [unowned self] pos in
                self.viewmodel.pushDetailModule(pos)
        }
    }
    
    private func setupRefresh() {
        var refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "刷新中")
        
        let refresh = Action<UIRefreshControl, Void, NSError> { [unowned self] refreshControl in
            return self.viewmodel.getFeaturedBusinesses()
                |> map { _ -> Void in }
                |> on(next: { [unowned self] _ in
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
        }
        
        refreshControl.addTarget(refresh.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .ValueChanged)
        
        self.tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
    
    /**
    React to Nearby Button and present NearbyViewController.
    */
    private func setupNearbyButton() {
        let pushNearby = Action<UIBarButtonItem, Void, NoError> { [unowned self] button in
            return SignalProducer<Void, NoError> { [unowned self] sink, disposable in
                self.viewmodel.pushNearbyModule()
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
        let pushProfile = Action<UIBarButtonItem, Void, NoError> { [unowned self] button in
            return SignalProducer<Void, NoError> { [unowned self] sink, disposable in
                self.viewmodel.pushProfileModule()
                sendCompleted(sink)
            }
        }
        
        profileButton.target = pushProfile.unsafeCocoaAction
        profileButton.action = CocoaAction.selector
    }
}