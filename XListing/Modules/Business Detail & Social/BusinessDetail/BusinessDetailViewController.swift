//
//  BusinessDetailViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveArray
import Dollar
import Cartography

private let UserCellIdentifier = "SocialBusiness_UserCell"
private let HeaderCellIdentifier = "HeaderCell"
private let MapCellIdentifier = "MapCell"
private let BusinessHeightRatio = 0.61
private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let ImageHeaderHeight = CGFloat(ScreenWidth) * CGFloat(BusinessHeightRatio)
private let UtilHeaderHeight = CGFloat(44)
private let TableViewStart = CGFloat(ImageHeaderHeight)+CGFloat(UtilHeaderHeight)
private let DetailNavigationMapViewControllerName = "DetailNavigationMapViewController"

public final class BusinessDetailViewController : XUIViewController {
    
    
    // MARK: - UI Controls
    private lazy var headerView: SocialBusinessHeaderView =  {
        let view = SocialBusinessHeaderView(frame: CGRectMake(0, 0, ScreenWidth, ImageHeaderHeight))
        view.bindToViewModel(self.viewmodel.headerViewModel)
        return view
    }()
    
    private lazy var utilityHeaderView: SocialBusiness_UtilityHeaderView = {
        let view = SocialBusiness_UtilityHeaderView(frame: CGRectMake(0, ImageHeaderHeight, ScreenWidth, UtilHeaderHeight))
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, TableViewStart, ScreenWidth, 600), style: UITableViewStyle.Grouped)
        
        // a hack which makes the gap between table view and utility header go away
        tableView.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        // a hack which makes the gap at the bottom of the table view go away
        tableView.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        tableView.showsHorizontalScrollIndicator = false
        tableView.opaque = true
        
        return tableView
    }()
    
    private var navigationMapViewController: DetailNavigationMapViewController!
    
    // MARK: - Properties
    private var viewmodel: IBusinessDetailViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(SocialBusiness_UserCell.self, forCellReuseIdentifier: UserCellIdentifier)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: HeaderCellIdentifier)
        tableView.registerClass(DetailMapTableViewCell.self, forCellReuseIdentifier: MapCellIdentifier)
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 25.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //remove the space between the left edge and seperator line
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        view.addSubview(headerView)
        view.addSubview(utilityHeaderView)
        view.addSubview(tableView)
        
        constrain(headerView) { header in
            header.leading == header.superview!.leading
            header.trailing == header.superview!.trailing
            header.top == header.superview!.top
            header.height == ImageHeaderHeight
        }
        
        constrain(headerView, utilityHeaderView) { header, utility in
            
            utility.leading == utility.superview!.leading
            utility.top == header.bottom
            utility.trailing == utility.superview!.trailing
            utility.height == UtilHeaderHeight
        }
        
        constrain(utilityHeaderView, tableView) { utility, table in
            table.leading == table.superview!.leading
            table.top == utility.bottom
            table.trailing == table.superview!.trailing
            table.height == table.superview!.height
        }
        
        navigationMapViewController = DetailNavigationMapViewController()
        
        compositeDisposable += navigationMapViewController.goBackProxy
            |> start(next: { handler in
                self.dismissViewControllerAnimated(true, completion: handler)
            })
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        compositeDisposable += utilityHeaderView.detailInfoProxy
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.SocialBusiness, "utilityHeaderView.detailInfoProxy")
            |> start(next: { [weak self] in
                println("go back to social business")
            })
        
        compositeDisposable += utilityHeaderView.startEventProxy
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.SocialBusiness, "utilityHeaderView.startEventProxy")
            |> start(next: { [weak self] in
                println("want to go")
            })

        
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
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IBusinessDetailViewModel) {
        self.viewmodel = viewmodel
    }
    
    // MARK: - Others
    
    private func presentNavigationMapViewController() {

        presentViewController(self.navigationMapViewController, animated: true) {
            self.navigationMapViewController.bindToViewModel(self.viewmodel.detailNavigationMapViewModel)
        }
        
    }
}
extension BusinessDetailViewController : UITableViewDelegate, UITableViewDataSource {
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    /**
    Asks the data source to return the number of sections in a table view.
    
    :param: tableView A table-view object requesting the cell.
    
    :returns: The number of sections in table view.
    */
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(HeaderCellIdentifier) as! UITableViewCell
            cell.textLabel?.text = "特设介绍"
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        }
        
        if indexPath.row == 1 {
            let mapCell = tableView.dequeueReusableCellWithIdentifier(MapCellIdentifier)
                as! DetailMapTableViewCell
            mapCell.bindToViewModel(viewmodel.detailAddressAndMapViewModel)
            compositeDisposable += mapCell.navigationMapProxy
                |> takeUntilPrepareForReuse(mapCell)
                |> start(next: { [weak self] in
                    self?.presentNavigationMapViewController()
                    })
            return mapCell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(UserCellIdentifier) as! SocialBusiness_UserCell
        return cell
    }

}
