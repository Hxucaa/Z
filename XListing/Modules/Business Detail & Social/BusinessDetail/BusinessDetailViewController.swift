//
//  BusinessDetailViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Dollar
import Cartography
import AMScrollingNavbar

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
private let UtilHeaderHeight = CGFloat(59)
private let TableViewStart = CGFloat(ImageHeaderHeight)+CGFloat(UtilHeaderHeight)
private let DetailNavigationMapViewControllerName = "DetailNavigationMapViewController"

final class BusinessDetailViewController : XUIViewController {
    
    typealias InputViewModel = (makeACall: Observable<Void>, dummy: Void) -> IBusinessDetailViewModel
    
    // MARK: - UI Controls
    private lazy var headerView: SocialBusinessHeaderView = {
        let view = SocialBusinessHeaderView(frame: CGRectMake(0, 0, ScreenWidth, ImageHeaderHeight))
        view.bindToCellData(self.viewmodel.businessName, location: self.viewmodel.city, eta: self.viewmodel.calculateEta(), imageURL: self.viewmodel.webSiteURL)
        return view
    }()
    
//    private lazy var utilityHeaderView: SocialBusiness_UtilityHeaderView = {
//        let view = SocialBusiness_UtilityHeaderView(frame: CGRectMake(0, ImageHeaderHeight, ScreenWidth, UtilHeaderHeight))
//        view.setDetailInfoButtonStyleSelected()
//        return view
//    }()
    
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
        tableView.delegate = self

        tableView.estimatedRowHeight = 25.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //remove the space between the left edge and seperator line
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        tableView.tableHeaderView = self.headerView
        // a hack which makes the gap between table view and utility header go away
//        tableView.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: CGFloat.min))
        // a hack which makes the gap at the bottom of the table view go away
        tableView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0)
        tableView.showsHorizontalScrollIndicator = false
        tableView.opaque = true
        
        return tableView
    }()
    
    var getAnimationMembers: UITableView {
        return tableView
    }
    
    private var navigationMapViewController: DetailNavigationMapViewController!
    
    private let descriptionHeaderTableViewCell = HeaderTableViewCell()
    private let descriptionTableViewCell = DescriptionTableViewCell()
    
    private let businessHourHeaderTableViewCell = HeaderTableViewCell()
    private let businessHourCell = BusinessHourCell()
    
    private let mapHeaderTableViewCell = HeaderTableViewCell()
    private let mapTableViewCell = DetailMapTableViewCell()
    private let phoneWebTableViewCell = DetailPhoneWebTableViewCell()
    private let addressTableViewCell = DetailAddressTableViewCell()
    
    
    // MARK: - Properties
    private var inputViewModel: InputViewModel!
    private var viewmodel: IBusinessDetailViewModel!
//    private let expandHours = MutableProperty<Bool>(false)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.delegate = self

        viewmodel = inputViewModel(
            makeACall: phoneWebTableViewCell.output.makeACall,
            dummy: ()
        )
        
//        view.addSubview(headerView)
//        view.addSubview(utilityHeaderView)
        view.addSubview(tableView)
        
        
        //        constrain(headerView) { header in
        //            header.leading == header.superview!.leading
        //            header.trailing == header.superview!.trailing
        //            header.top == header.superview!.top
        //            header.height == ImageHeaderHeight
        //        }
        
        //        constrain(headerView, utilityHeaderView) { header, utility in
        //
        //            utility.leading == utility.superview!.leading
        //            utility.top == header.bottom
        //            utility.trailing == utility.superview!.trailing
        //            utility.height == UtilHeaderHeight
        //        }
        
        constrain(tableView) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.bottom == $0.superview!.bottom
        }
        
//        self.rx_observe(UITableViewDataSource.self, "tableView:indexPath:")
        descriptionHeaderTableViewCell.bindToData("特设介绍")
        descriptionTableViewCell.bindToData(viewmodel.descriptor)
        
        businessHourHeaderTableViewCell.bindToData("营业时间")
        businessHourCell.bindViewModel(viewmodel.businessHourViewModel)
//        compositeDisposable += cell.expandBusinessHoursProxy
//            .takeUntilPrepareForReuse(cell)
//            .startWithNext { [weak self] vc in
//                self?.tableView.beginUpdates()
//                self?.tableView.endUpdates()
//            }
        
        mapHeaderTableViewCell.bindToData("地址和信息")
        addressTableViewCell.bindToData(viewmodel.fullAddress)
        phoneWebTableViewCell.bindToData(viewmodel.phoneDisplay, websiteDisplay: viewmodel.websiteDisplay)
        mapTableViewCell.bindToData(viewmodel.annotation, cellMapRegion: viewmodel.cellMapRegion, mapViewDelegate: self)
        
        viewmodel.callStatus
            .subscribe()
            .addDisposableTo(disposeBag)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        navigationMapViewController = DetailNavigationMapViewController()
        
        navigationMapViewController.bindToData(viewmodel.annotation, region: viewmodel.meAndBusinessRegion)
        
        //        compositeDisposable += navigationMapViewController.goBackProxy
        //            .startWithNext { [weak self] handler in
        //                self?.dismissViewControllerAnimated(true, completion: handler)
        //            }
        navigationMapViewController.output.navigateBack
            .subscribeNext { [weak self] in
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        
//        utilityHeaderView.setDetailInfoButtonStyleSelected()
        
//        compositeDisposable += utilityHeaderView.detailInfoProxy
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.SocialBusiness, signalName: "utilityHeaderView.detailInfoProxy")
//            .startWithNext { [weak self] in
//                self?.navigationController?.popViewControllerAnimated(true)
//            }
//        
//        compositeDisposable += utilityHeaderView.startEventProxy
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.SocialBusiness, signalName: "utilityHeaderView.startEventProxy")
//            .startWithNext { _ in
//                print("want to go")
//            }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        (self.navigationController as? ScrollingNavigationController)?.showNavbar(animated: true)
    }
    
    // MARK: - Bindings
    
    func bindToViewModel(inputViewModel: InputViewModel) {
        self.inputViewModel = inputViewModel
    }

    // MARK: - Others
    
    private func presentNavigationMapViewController() {
        presentViewController(navigationMapViewController, animated: true, completion: nil)
    }
}
extension BusinessDetailViewController : UITableViewDelegate, UITableViewDataSource {
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    - parameter tableView: The table-view object requesting this information.
    - parameter section:   An index number identifying a section in tableView.
    
    - returns: The number of rows in section.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    - parameter tableView: A table-view object requesting the cell.
    
    - returns: The number of sections in table view.
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    - parameter tableView: A table-view object requesting the cell.
    - parameter indexPath: An index path locating a row in tableView.
    
    - returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        
        switch Section(rawValue: section)! {
            
        case .Description:
            switch Description(rawValue: row)! {
            case .Header:
                return descriptionHeaderTableViewCell
            case .Content:
                return descriptionTableViewCell
            }
            
        case .BusinessHours:
            switch BusinessHours(rawValue: row)! {
            case .Header:
                return businessHourHeaderTableViewCell
            case .BusinessHours:
                return businessHourCell
            }
            
        case .Map:
            switch Map(rawValue: row)! {
            case .Header:
                return mapHeaderTableViewCell
            case .Map:
                return mapTableViewCell
            case .Address:
                return addressTableViewCell
            case .PhoneWeb:
                return phoneWebTableViewCell
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        switch Section(rawValue: section)! {
        case .Map:
            switch Map(rawValue: row)! {
            case .Map:
                presentNavigationMapViewController()
                break
            case .Address:
                presentNavigationMapViewController()
                break
            default:
                break
            }
        default:
            break
        }
    }
}

//extension BusinessDetailViewController : UINavigationControllerDelegate {
//    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        if fromVC is BusinessDetailViewController && toVC is SocialBusinessViewController && operation == .Pop {
//            return BDtoSBAnimator(tableView: tableView, headerView: headerView, utilityHeaderView: utilityHeaderView, headerVM: viewmodel.headerViewModel)
//        }
//        return nil
//    }
//}


extension BusinessDetailViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.image = UIImage(asset: UIImage.Asset.MapPin)
        annotationView.canShowCallout = true
        annotationView.annotation = annotation
        
        return annotationView
    }
}