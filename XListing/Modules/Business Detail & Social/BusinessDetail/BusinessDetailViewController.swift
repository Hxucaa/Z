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
private let BusinessHourCellIdentifier = "BusinessHourCellIdentifier"
private let MapCellIdentifier = "MapCell"
private let AddressCellIdentifier = "AddressCell"
private let PhoneWebCellIdentifier = "PhoneWebCell"
private let DescriptionCellIdentifier = "DescriptionTableviewCell"

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
        let tableView = UITableView(frame: CGRectMake(0, TableViewStart, ScreenWidth, 1000), style: UITableViewStyle.Grouped)
        
        tableView.registerClass(SocialBusiness_UserCell.self, forCellReuseIdentifier: UserCellIdentifier)
        tableView.registerClass(DescriptionTableViewCell.self, forCellReuseIdentifier: DescriptionCellIdentifier)
        tableView.registerClass(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderCellIdentifier)
        tableView.registerClass(BusinessHourCell.self, forCellReuseIdentifier: BusinessHourCellIdentifier)
        tableView.registerClass(DetailMapTableViewCell.self, forCellReuseIdentifier: MapCellIdentifier)
        tableView.registerClass(DetailAddressTableViewCell.self, forCellReuseIdentifier: AddressCellIdentifier)
        tableView.registerClass(DetailPhoneWebTableViewCell.self, forCellReuseIdentifier: PhoneWebCellIdentifier)
        tableView.dataSource = self

        tableView.estimatedRowHeight = 25.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //remove the space between the left edge and seperator line
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        // a hack which makes the gap between table view and utility header go away
        tableView.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        // a hack which makes the gap at the bottom of the table view go away
        tableView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
        tableView.showsHorizontalScrollIndicator = false
        tableView.opaque = true
        
        return tableView
    }()
    
    public var getAnimationMembers: UITableView {
        return tableView
    }
    
    private var navigationMapViewController: DetailNavigationMapViewController!
    
    // MARK: - Properties
    private var viewmodel: IBusinessDetailViewModel!
    private let compositeDisposable = CompositeDisposable()
    private let expandHours = MutableProperty<Bool>(false)
    
    private enum Section : Int {
        case Description, BusinessHours, Map
    }
    
    private enum Description : Int {
        case Header, Content
    }
    
    private enum BusinessHours: Int {
        case Header, BusinessHours
    }
    
    private enum Map : Int {
        case Header, Map, Address, PhoneWeb
    }
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.addSubview(headerView)
        view.addSubview(utilityHeaderView)
        view.addSubview(tableView)

        navigationMapViewController = DetailNavigationMapViewController()
        
        compositeDisposable += navigationMapViewController.goBackProxy
            |> start(next: { handler in
                self.dismissViewControllerAnimated(true, completion: handler)
            })
        
        tableView.reloadData()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        compositeDisposable += utilityHeaderView.detailInfoProxy
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.SocialBusiness, "utilityHeaderView.detailInfoProxy")
            |> start(next: { [weak self] in
                self?.navigationController?.popViewControllerAnimated(true)
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
            table.bottom == table.superview!.bottom - 44
        }
        
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
        switch Section(rawValue: section)! {
        case .Description:
            return 2
        case .BusinessHours:
            return 2
        case .Map:
            return 4
        }
    }
    
    /**
    Asks the data source to return the number of sections in a table view.
    
    :param: tableView A table-view object requesting the cell.
    
    :returns: The number of sections in table view.
    */
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        
        switch Section(rawValue: section)! {
            
        case .Description:
            switch Description(rawValue: row)! {
            case .Header:
                let cell = tableView.dequeueReusableCellWithIdentifier(HeaderCellIdentifier) as! HeaderTableViewCell
                cell.setLabelText("特设介绍")
                return cell
                
            case .Content:
                let cell = tableView.dequeueReusableCellWithIdentifier(DescriptionCellIdentifier) as! DescriptionTableViewCell
                
                return cell
            }
            
        case .BusinessHours:
            switch BusinessHours(rawValue: row)! {
            case .Header:
                let cell = tableView.dequeueReusableCellWithIdentifier(HeaderCellIdentifier) as! HeaderTableViewCell
                cell.setLabelText("营业时间")
                return cell
                
            case .BusinessHours:
                let cell = tableView.dequeueReusableCellWithIdentifier(BusinessHourCellIdentifier) as! BusinessHourCell
                cell.bindViewModel(viewmodel.businessHourViewModel)
                compositeDisposable += cell.expandBusinessHoursProxy
                    |> takeUntilPrepareForReuse(cell)
                    |> start(next: { [weak self] vc in
                        self?.tableView.beginUpdates()
                        self?.tableView.endUpdates()
                    })
                return cell
            }
            
        case .Map:
            switch Map(rawValue: row)! {
            case .Header:
                let cell = tableView.dequeueReusableCellWithIdentifier(HeaderCellIdentifier) as! HeaderTableViewCell
                cell.setLabelText("地址和信息")
                return cell
            case .Map:
                let mapCell = tableView.dequeueReusableCellWithIdentifier(MapCellIdentifier) as! DetailMapTableViewCell
                mapCell.bindToViewModel(viewmodel.detailAddressAndMapViewModel)
                compositeDisposable += mapCell.navigationMapProxy
                    |> takeUntilPrepareForReuse(mapCell)
                    |> start(next: { [weak self] in
                        self?.presentNavigationMapViewController()
                    })
                return mapCell
                
            case .Address:
                let addressCell = tableView.dequeueReusableCellWithIdentifier(AddressCellIdentifier) as! DetailAddressTableViewCell
                addressCell.bindToViewModel(viewmodel.detailAddressAndMapViewModel)
                compositeDisposable += addressCell.navigationMapProxy
                    |> takeUntilPrepareForReuse(addressCell)
                    |> start(next: { [weak self] in
                        self?.presentNavigationMapViewController()
                    })
                return addressCell
                
            case .PhoneWeb:
                let phoneWebCell = tableView.dequeueReusableCellWithIdentifier(PhoneWebCellIdentifier) as! DetailPhoneWebTableViewCell
                phoneWebCell.bindToViewModel(viewmodel.detailPhoneWebViewModel)
                compositeDisposable += phoneWebCell.presentWebViewProxy
                    |> takeUntilPrepareForReuse(phoneWebCell)
                    |> start(next: { [weak self] vc in
                        self?.presentViewController(vc, animated: true, completion: nil)
                    })
                return phoneWebCell
            
            }
        }
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
}

extension BusinessDetailViewController : UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is BusinessDetailViewController && toVC is SocialBusinessViewController && operation == .Pop {
            return ReverseSlideAnimator(tableView: tableView, headerView: headerView, utilityHeaderView: utilityHeaderView, headerVM: viewmodel.headerViewModel)
        }
        return nil
    }
}
