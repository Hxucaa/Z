//
//  ViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import AMScrollingNavbar
import INSPullToRefresh

private let CellIdentifier = "FeaturedListBusinessTableViewCell"

final class FeaturedListViewController: XUIViewController, UITableViewDelegate, ScrollingNavigationControllerDelegate {
    typealias InputViewModel = (modelSelected: Driver<FeaturedListCellData>, refreshTrigger: Observable<Void>) -> IFeaturedListViewModel
    
    // MARK: - UI Controls
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        
        tableView.registerClass(FeaturedListBusinessTableViewCell.self, forCellReuseIdentifier: CellIdentifier)

        // makes the gap between table view and navigation bar go away
        tableView.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        // makes the gap at the bottom of the table view go away
        tableView.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))

        tableView.rowHeight = round(UIScreen.mainScreen().bounds.width * CGFloat(0.62))
        tableView.separatorStyle = .None
        tableView.delegate = self

        return tableView
    }()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, FeaturedListCellData>>()
    
    // MARK: - Properties
    private var inputViewModel: InputViewModel!
    private var viewmodel: IFeaturedListViewModel!
    private var scrollingNavControll: ScrollingNavigationController? {
        return navigationController as? ScrollingNavigationController
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = self.tableView
        
        title = "推荐"
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.x_PrimaryColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        scrollingNavControll?.scrollingNavbarDelegate = self
        
        view.opaque = true
        view.backgroundColor = UIColor.x_FeaturedTableBG()
        
        view.addSubview(tableView)
        
        dataSource.configureCell = { (_, tv, ip, cellData) in
            let cell = tv.dequeueReusableCellWithIdentifier(CellIdentifier) as! FeaturedListBusinessTableViewCell
            cell.bindToCellData(cellData)
            
            return cell
        }
        
        // enable pull to refresh on the table
        tableView.enablePullToRefresh()
        
        
        // initialize view model
        viewmodel = inputViewModel(
            // the model which backs the cell that is being tapped
            modelSelected: tableView.rx_modelSelected(FeaturedListCellData).asDriver(),
            // refresh the collection data
            refreshTrigger: tableView.rx_startWithRefreshTrigger)
        
        // bind collection data source to table view
        viewmodel.collectionDataSource
            .drive(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Use followScrollView(_: delay:) to start following the scrolling of a scrollable view (e.g.: a UIScrollView or UITableView).
        scrollingNavControll?.followScrollView(tableView, delay: 50.0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        // Stop the behaviour when view will
        scrollingNavControll?.stopFollowingScrollView()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // if the view controller with the scroll view pushes new controllers, call showNavbar(animated:) in your viewWillDisappear(animated:)
        scrollingNavControll?.showNavbar(animated: true)
    }
    
    deinit {
        // FIXME: Maybe this should be in `viewDidDisappear` ??? However, if so, then when the view controller reappears will have to rebind??
        // have to remove pull to refresh from table when the view goes away
        tableView.removePullToRefresh()
    }

    override func viewWillLayoutSubviews() {
        tableView.frame = self.view.bounds
    }
    
    // MARK: - Bindings

    func bindToViewModel(inputViewModel: InputViewModel) {
        self.inputViewModel = inputViewModel
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // table view is being scrolled down, not up
        guard velocity.y > 0.0 &&
            /// Only fetch more data if both pull to refresh and infinity scroll are not already triggered. We don't want to trigger network request repeatedly.
            tableView.ins_pullToRefreshBackgroundView.state != INSPullToRefreshBackgroundViewState.Triggered else {
                return
        }
        
        // targetContentOffset is the offset of the top-left point of the top of the cells that are being displayed
        let contentHeight = targetContentOffset.memory.y
        // height of the table
        let tableHeight = tableView.bounds.size.height
        // content inset
        let contentInsetBottom = tableView.contentInset.bottom
        // get the index path of the bottom cell that is being displayed on table view
        let indexPath = tableView.indexPathForRowAtPoint(CGPoint(x: 0.0, y: contentHeight + tableHeight - contentInsetBottom))
        
        guard indexPath?.row != nil else {
            return
        }
        
        viewmodel.fetchMoreTrigger.onNext()
    }
}
