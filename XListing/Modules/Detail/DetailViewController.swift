//
//  DetailViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import MapKit
import WebKit

private let DetailNavigationMapViewControllerName = "DetailNavigationMapViewController"

public final class DetailViewController : XUIViewController, UITableViewDelegate {
    
    // MARK: - UI Controls
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var shareBarButtonItem: UIBarButtonItem!
    private var navigationMapViewController: DetailNavigationMapViewController!
    
    // MARK: - Properties
    private var viewmodel: IDetailViewModel!
    private let compositeDisposable = CompositeDisposable()
    private let expandHours = MutableProperty<Bool>(false)
    
    private enum Section : Int {
        case Primary, 推荐, 营业, 特设, 其他
    }
    
    private enum Primary : Int {
        case Image, Info, 参与
    }
    
    private enum 推荐 : Int {
        case Header, 推荐物品
    }
    
    private enum 营业 : Int {
        case Header, 营业时间
    }
    
    private enum 特设 : Int {
        case Header, 介绍
    }
    
    private enum 其他 : Int {
        case Header, Map, Address, PhoneAndWeb
    }
    
    // MARK: - Setups
    
    public override func loadView() {
        super.loadView()
        
        navigationMapViewController = UIStoryboard(name: "Detail", bundle: nil).instantiateViewControllerWithIdentifier(DetailNavigationMapViewControllerName) as! DetailNavigationMapViewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupShareBarButtonItem()
        setupTableView()
        
        compositeDisposable += navigationMapViewController.goBackProxy
            |> start(next: { handler in
                self.dismissViewControllerAnimated(true, completion: handler)
            })
        
        // fill status bar with color
        let statusView = UIView(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 20))
        statusView.backgroundColor = UIColor.x_PrimaryColor()
        view.addSubview(statusView)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupShareBarButtonItem() {
        let share = Action<UIBarButtonItem, Void, NoError> { button in
            return SignalProducer { sink, disposable in
                var someText = "blah"
                let google = NSURL(string:"http://google.com/")!
                
                let activityViewController = UIActivityViewController(
                    activityItems: [someText, google],
                    applicationActivities:nil)
                
                self.presentViewController(activityViewController,
                    animated: true,
                    completion: { sendCompleted(sink) })
                
            }
        }

        shareBarButtonItem.target = share.unsafeCocoaAction
        shareBarButtonItem.action = CocoaAction.selector
    }
    
    private func setupTableView() {
        // a hack which makes the gap between table view and navigation bar go away
        tableView.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        // a hack which makes the gap at the bottom of the table view go away
        tableView.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        tableView.estimatedRowHeight = 35.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        compositeDisposable += rac_signalForSelector(Selector("tableView:didSelectRowAtIndexPath:"), fromProtocol: UITableViewDelegate.self).toSignalProducer()
            |> logLifeCycle(LogContext.Detail, "tableView:didSelectRowAtIndexPath:")
            |> map { ($0 as! RACTuple).second as! NSIndexPath }
            |> start(next: { indexPath in
                let section = indexPath.section
                let row = indexPath.row
                
                switch Section(rawValue: section)! {
                case .营业:
                    switch 营业(rawValue: row)! {
                    // expand the business hours cell
                    case .营业时间:
                        self.expandHours.put(!self.expandHours.value)
                        
                        self.tableView.reloadData()
                    default: break
                    }
                case .Primary:
                    switch Primary(rawValue: row)! {
                    // send data
                    case .参与:
                        self.viewmodel.pushWantToGo()
                    default: break
                    }
                default: break
                }
            })
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    deinit {
        compositeDisposable.dispose()
        DetailLogVerbose("Detail View Controller deinitializes.")
    }

    // MARK: - Bindings
    
    public func bindToViewModel(detailViewModel: IDetailViewModel) {
        viewmodel = detailViewModel
        
        navigationItem.rac_title <~ self.viewmodel.businessName
    }
    
    // MARK: - Others
    
    private func presentNavigationMapViewController() {
        
        presentViewController(self.navigationMapViewController, animated: true) {
            self.navigationMapViewController.bindToViewModel(self.viewmodel.detailNavigationMapViewModel)
        }
    }
}

/**
*  UITableViewDataSource
*/
extension DetailViewController : UITableViewDataSource {
    
    /**
    Asks the data source to return the number of sections in the table view.
    
    :param: tableView An object representing the table view requesting this information.
    
    :returns: The number of sections in tableView. The default value is 1.
    */
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Section(rawValue: section)! {
            case .Primary: return 3
            case .推荐: return 2
            case .营业: return 2
            case .特设: return 2
            case .其他: return 4
        }
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
            
        case .Primary:
            switch Primary(rawValue: row)! {
            case .Image:
                let imageCell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! DetailImageTableViewCell
                imageCell.bindToViewModel(viewmodel.detailImageViewModel)
                return imageCell
            case .Info:
                
                var bizInfoCell = tableView.dequeueReusableCellWithIdentifier("BizInfoCell", forIndexPath: indexPath) as! DetailBizInfoTableViewCell
                
                bizInfoCell.bindToViewModel(viewmodel.detailBizInfoViewModel)
                
                return bizInfoCell
                
            case .参与:
                let cell = tableView.dequeueReusableCellWithIdentifier("ParticipationCell", forIndexPath: indexPath) as! DetailParticipationTableViewCell
                cell.bindToViewModel(viewmodel.detailParticipationViewModel)
                return cell
            }
            
        case .推荐:
            switch 推荐(rawValue: row)! {
            case .Header:
                let cell = tableView.dequeueReusableCellWithIdentifier("RecommendationHeader", forIndexPath: indexPath) as! UITableViewCell
                cell.layoutMargins = UIEdgeInsetsZero
                cell.separatorInset = UIEdgeInsetsZero
                
                return cell
            case .推荐物品:
                let cell = tableView.dequeueReusableCellWithIdentifier("WhatsGoodCell", forIndexPath: indexPath) as! UITableViewCell
                cell.layoutMargins = UIEdgeInsetsZero
                cell.separatorInset = UIEdgeInsetsZero
                return cell
            }
            
        case .营业:
            switch 营业(rawValue: row)! {
            case .Header:
                let cell = tableView.dequeueReusableCellWithIdentifier("HoursHeader", forIndexPath: indexPath) as! UITableViewCell
                cell.layoutMargins = UIEdgeInsetsZero
                cell.separatorInset = UIEdgeInsetsZero
                return cell
            case .营业时间:
                if (expandHours.value) {
                    let cell = tableView.dequeueReusableCellWithIdentifier("HoursCell", forIndexPath: indexPath) as! UITableViewCell
                    cell.layoutMargins = UIEdgeInsetsZero
                    cell.separatorInset = UIEdgeInsetsZero
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("CurrentHoursCell", forIndexPath: indexPath) as! UITableViewCell
                    cell.layoutMargins = UIEdgeInsetsZero
                    cell.separatorInset = UIEdgeInsetsZero
                    cell.accessoryView = UIImageView(image: UIImage(named: ImageAssets.downArrow))
                    cell.textLabel?.text = "今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM"
                    return cell
                }
            }
            
        case .特设:
            switch 特设(rawValue: row)! {
            case .Header:
                let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionHeader", forIndexPath: indexPath) as! UITableViewCell
                cell.layoutMargins = UIEdgeInsetsZero
                cell.separatorInset = UIEdgeInsetsZero
                return cell
            case .介绍:
                let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: indexPath) as! UITableViewCell
                cell.layoutMargins = UIEdgeInsetsZero
                cell.separatorInset = UIEdgeInsetsZero
                return cell
            }
            
        case .其他:
            switch 其他(rawValue: row)! {
            case .Header:
                let cell = tableView.dequeueReusableCellWithIdentifier("AddressAndInfoHeader", forIndexPath: indexPath) as! UITableViewCell
                cell.layoutMargins = UIEdgeInsetsZero
                cell.separatorInset = UIEdgeInsetsZero
                return cell
            case .Map:
                let mapCell = tableView.dequeueReusableCellWithIdentifier("MapCell", forIndexPath: indexPath) as! DetailMapTableViewCell
                mapCell.bindToViewModel(viewmodel.detailAddressAndMapViewModel)
                
                compositeDisposable += mapCell.navigationMapProxy
                    |> takeUntilPrepareForReuse(mapCell)
                    |> start(next: { [weak self] in
                        self?.presentNavigationMapViewController()
                    })
                
                return mapCell
            case .Address:
                let addressCell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! DetailAddressTableViewCell
                addressCell.bindToViewModel(viewmodel.detailAddressAndMapViewModel)
                
                compositeDisposable += addressCell.navigationMapProxy
                    |> takeUntilPrepareForReuse(addressCell)
                    |> start(next: { [weak self] in
                        self?.presentNavigationMapViewController()
                    })
                
                return addressCell
            case .PhoneAndWeb:
                let phoneWebCell = tableView.dequeueReusableCellWithIdentifier("PhoneWebSplitCell", forIndexPath: indexPath) as! DetailPhoneWebTableViewCell
                
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