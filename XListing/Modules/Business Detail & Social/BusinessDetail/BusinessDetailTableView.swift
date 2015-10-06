//
//  BusinessDetailTableView.swift
//  
//
//  Created by Bruce Li on 2015-10-03.
//
//

import UIKit
import ReactiveCocoa

private let UserCellIdentifier = "SocialBusiness_UserCell"
private let HeaderCellIdentifier = "HeaderCell"
private let BusinessHourCellIdentifier = "BusinessHourCellIdentifier"
private let MapCellIdentifier = "MapCell"
private let AddressCellIdentifier = "AddressCell"
private let PhoneWebCellIdentifier = "PhoneWebCell"
private let DescriptionCellIdentifier = "DescriptionTableviewCell"

public final class BusinessDetailTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        registerClass(SocialBusiness_UserCell.self, forCellReuseIdentifier: UserCellIdentifier)
        registerClass(DescriptionTableViewCell.self, forCellReuseIdentifier: DescriptionCellIdentifier)
        registerClass(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderCellIdentifier)
        registerClass(BusinessHourCell.self, forCellReuseIdentifier: BusinessHourCellIdentifier)
        registerClass(DetailMapTableViewCell.self, forCellReuseIdentifier: MapCellIdentifier)
        registerClass(DetailAddressTableViewCell.self, forCellReuseIdentifier: AddressCellIdentifier)
        registerClass(DetailPhoneWebTableViewCell.self, forCellReuseIdentifier: PhoneWebCellIdentifier)
        dataSource = self
        delegate = self
        
        estimatedRowHeight = 25.0
        rowHeight = UITableViewAutomaticDimension
        
        //remove the space between the left edge and seperator line
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        
        // a hack which makes the gap between table view and utility header go away
        tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: CGFloat.min))
        // a hack which makes the gap at the bottom of the table view go away
        contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
        showsHorizontalScrollIndicator = false
        opaque = true
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
//                cell.bindViewModel(viewmodel.businessHourViewModel)
//                compositeDisposable += cell.expandBusinessHoursProxy
//                    |> takeUntilPrepareForReuse(cell)
//                    |> start(next: { [weak self] vc in
//                        beginUpdates()
//                        endUpdates()
//                        })
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
//                mapCell.bindToViewModel(viewmodel.detailAddressAndMapViewModel)
//                compositeDisposable += mapCell.navigationMapProxy
//                    |> takeUntilPrepareForReuse(mapCell)
//                    |> start(next: { [weak self] in
//                        self?.presentNavigationMapViewController()
//                        })
                return mapCell
                
            case .Address:
                let addressCell = tableView.dequeueReusableCellWithIdentifier(AddressCellIdentifier) as! DetailAddressTableViewCell
//                addressCell.bindToViewModel(viewmodel.detailAddressAndMapViewModel)
//                compositeDisposable += addressCell.navigationMapProxy
//                    |> takeUntilPrepareForReuse(addressCell)
//                    |> start(next: { [weak self] in
//                        self?.presentNavigationMapViewController()
//                        })
                return addressCell
                
            case .PhoneWeb:
                let phoneWebCell = tableView.dequeueReusableCellWithIdentifier(PhoneWebCellIdentifier) as! DetailPhoneWebTableViewCell
//                phoneWebCell.bindToViewModel(viewmodel.detailPhoneWebViewModel)
//                compositeDisposable += phoneWebCell.presentWebViewProxy
//                    |> takeUntilPrepareForReuse(phoneWebCell)
//                    |> start(next: { [weak self] vc in
//                        self?.presentViewController(vc, animated: true, completion: nil)
//                        })
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
