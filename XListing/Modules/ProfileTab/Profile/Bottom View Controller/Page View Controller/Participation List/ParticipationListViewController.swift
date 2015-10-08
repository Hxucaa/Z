//
//  ParticipationListViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import AVOSCloud
import Dollar
import Cartography

private let BusinessCellIdentifier = "BusinessCell"

public final class ParticipationListViewController : UIViewController {
    
    
    // MARK: - UI Controls
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        view.registerClass(ParticipationListCellView.self, forCellReuseIdentifier: BusinessCellIdentifier)
        view.rowHeight = 90
        view.dataSource = self
        
        return view
    }()
    
    // MARK: - Properties
    private var viewmodel: ParticipationListViewModel!
    
    // MARK: - Initializers
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        constrain(tableView) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.bottom == $0.superview!.bottom
        }
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        // create a signal associated with `tableView:didSelectRowAtIndexPath:` form delegate `UITableViewDelegate`
//        // when the specified row is now selected
//        compositeDisposable += rac_signalForSelector(Selector("tableView:didSelectRowAtIndexPath:"), fromProtocol: UITableViewDelegate.self).toSignalProducer()
//            // forwards events from producer until the view controller is going to disappear
//            |> takeUntilViewWillDisappear(self)
//            |> map { ($0 as! RACTuple).second as! NSIndexPath }
//            |> logLifeCycle(LogContext.Profile, "tableView:didSelectRowAtIndexPath:")
//            |> start(
//                next: { [weak self] indexPath in
//                    self?.viewmodel.pushSocialBusinessModule(indexPath.row, animated: true)
//                }
//            )
//
//        compositeDisposable += rac_signalForSelector(Selector("tableView:commitEditingStyle:forRowAtIndexPath:"), fromProtocol: UITableViewDataSource.self).toSignalProducer()
//            // forwards events from producer until the view controller is going to disappear
//            |> takeUntilViewWillDisappear(self)
//            |> map { parameters -> (UITableViewCellEditingStyle, NSIndexPath) in
//                let tuple = parameters as! RACTuple
//                return (tuple.second as! UITableViewCellEditingStyle, tuple.third as! NSIndexPath)
//            }
//            |> logLifeCycle(LogContext.Profile, "tableView:commitEditingStyle:forRowAtIndexPath:")
//            |> start(
//                next: { [weak self] editingStyle, indexPath in
//                    if let this = self {
//                        if editingStyle == UITableViewCellEditingStyle.Delete {
//                            this.viewmodel.undoParticipation(indexPath.row)
//                                |> start()
//                            this.viewmodel.profileBusinessViewModelArr.value.removeAtIndex(indexPath.row)
//                            this.tableView.reloadData()
//                        }
//                    }
//                }
//            )
//
        
        tableView.delegate = nil
        tableView.delegate = self
//
//        viewmodel.profileBusinessViewModelArr.producer
//            |> start(next: { [weak self] _ in
//                self?.tableView.reloadData()
//            })

    }
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: ParticipationListViewModel) {
        self.viewmodel = viewmodel
    }
}

/**
*  UITableViewDataSource
*/
extension ParticipationListViewController : UITableViewDataSource, UITableViewDelegate {
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return numberOfChats
        return viewmodel.collectionDataSource.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var businessCell = tableView.dequeueReusableCellWithIdentifier(BusinessCellIdentifier, forIndexPath: indexPath) as! ParticipationListCellView
        businessCell.bindToViewModel(viewmodel.collectionDataSource.array[indexPath.row])
        
        return businessCell
        
    }
}

/**
*  UITableViewDelegate
*/
extension ParticipationListViewController : UITableViewDelegate {
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
}