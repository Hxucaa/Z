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

public final class BusinessDetailViewController : XUIViewController {
    
    // MARK: - UI Controls
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, 600, 600), style: UITableViewStyle.Grouped)
        tableView.showsHorizontalScrollIndicator = false
        tableView.opaque = true
        
        return tableView
    }()
    
    // MARK: - Properties
    private var viewmodel: IBusinessDetailViewModel!
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(SocialBusiness_UserCell.self, forCellReuseIdentifier: UserCellIdentifier)
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        constrain(tableView) { view in
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
        }
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
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
}
extension BusinessDetailViewController : UITableViewDelegate, UITableViewDataSource {
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
        let cell = tableView.dequeueReusableCellWithIdentifier(UserCellIdentifier) as! SocialBusiness_UserCell
        return cell
    }
    
    /**
    Asks the data source for a view to be placed in the header of the table view
    
    :param: tableView A table-view object requesting the cell.
    :param: section The section that the header will be inserted in
    
    :returns: The view that will be displayed in the header for the specified section
    */
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var deviceWidth = UIScreen.mainScreen().bounds.size.width
        var imageView = UIImageView(frame: CGRectMake(0, 0, deviceWidth, deviceWidth*0.61))
        imageView.rac_image <~ viewmodel.detailImageViewModel.coverImage
        return imageView
    }
    
    /**
    Asks the data source to return the height for the header of a given section
    
    :param: tableView A table-view object requesting the cell.
    :param: section The section the height is being specified for
    
    :returns: The height of the header for the specified section
    */
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var deviceWidth = UIScreen.mainScreen().bounds.size.width
        return deviceWidth*0.61
    }
}
