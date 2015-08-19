//
//  WantToGoListViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-29.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import SDWebImage
import ReactiveCocoa

private let CellIdentifier = "Cell"

public final class WantToGoListViewController: XUIViewController {
    
    // MARK: - UI Controls
    @IBOutlet private weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var infinityScrollConductor: InfinityScrollConductor<UITableView, WantToGoListViewModel> = InfinityScrollConductor<UITableView, WantToGoListViewModel>(tableView: self.tableView, infinityScrollable: self.viewmodel as! WantToGoListViewModel)
    private lazy var pullToRefreshConductor: PullToRefreshConductor<UITableView, WantToGoListViewModel> = PullToRefreshConductor<UITableView, WantToGoListViewModel>(tableView: self.tableView, pullToRefreshable: self.viewmodel as! WantToGoListViewModel)
    
    // MARK: - Properties
    private var viewmodel: IWantToGoListViewModel!
    
    
    // MARK: - Setup
    public override func viewDidLoad() {
        super.viewDidLoad()

        infinityScrollConductor.setup()
        pullToRefreshConductor.setup(0)
        genderSegmentedControl?.addTarget(self, action: "switchSegment", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.dataSource = self
    }
    
    deinit {
        tableView.ins_removeInfinityScroll()
        tableView.ins_removePullToRefresh()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func switchSegment(){
        if (genderSegmentedControl.selectedSegmentIndex == 0) {
            // Male Segment
            viewmodel.showMaleUsers()
        } else if (genderSegmentedControl.selectedSegmentIndex == 1) {
            // Female Segment
            viewmodel.showFemaleUsers()
        }
        
        tableView.reloadData()
    }
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: IWantToGoListViewModel) {
        self.viewmodel = viewmodel
        
        self.viewmodel.getWantToGoUsers()
            |> start()
    }
    
}

extension WantToGoListViewController : UITableViewDataSource, UITableViewDelegate {
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.wantToGoViewModelArr.value.count
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! WantToGoListViewCell
        cell.bindViewModel(viewmodel.wantToGoViewModelArr.value[indexPath.row])
        return cell
    }
}
