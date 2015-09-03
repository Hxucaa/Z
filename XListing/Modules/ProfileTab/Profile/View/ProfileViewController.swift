//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import AVOSCloud
import Dollar
import Cartography

private let BusinessCellIdentifier = "BusinessCell"

public final class ProfileViewController : XUIViewController {

    // MARK: - UI Controls
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var tabView: UIView!
    private var headerViewContent: ProfileHeaderView!
    
    // MARK: - Properties
    private var viewmodel: IProfileViewModel!
    private var firstSegSelected = true
    private var selectedBusinessChoiceIndex = 0
    private let compositeDisposable = CompositeDisposable()

    // MARK: - Setups
    public override func loadView() {
        super.loadView()
        
        headerViewContent = NSBundle.mainBundle().loadNibNamed("ProfileHeaderView", owner: self, options: nil).first as! ProfileHeaderView
        headerView.addSubview(headerViewContent)
        constrain(headerViewContent) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
        }
        
        let tabViewContent = NSBundle.mainBundle().loadNibNamed("ProfileTabView", owner: self, options: nil).first as! ProfileTabView
        tabView.addSubview(tabViewContent)
        
        let nib = UINib(nibName: "ProfileBusinessCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: BusinessCellIdentifier)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "个人"
        
        viewmodel.profileHeaderViewModel.producer
            |> ignoreNil
            |> start(next: { [weak self] viewmodel in
                self?.headerViewContent.bindViewModel(viewmodel)
            })
        
        tableView.rowHeight = 90
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // add statusBarBackgroundView to navigationController
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.hidesBarsOnSwipe = false
        
        willAppearTableView()
        
        compositeDisposable += headerViewContent.editProxy
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Profile, "headerViewContent.editProxy")
            |> start(
                next: { [weak self] in
                    self?.viewmodel.presentProfileEditModule(true, completion: nil)
                }
            )
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func willAppearTableView() {
        
        // create a signal associated with `tableView:didSelectRowAtIndexPath:` form delegate `UITableViewDelegate`
        // when the specified row is now selected
        compositeDisposable += rac_signalForSelector(Selector("tableView:didSelectRowAtIndexPath:"), fromProtocol: UITableViewDelegate.self).toSignalProducer()
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> map { ($0 as! RACTuple).second as! NSIndexPath }
            |> logLifeCycle(LogContext.Profile, "tableView:didSelectRowAtIndexPath:")
            |> start(
                next: { [weak self] indexPath in
                    self?.viewmodel.pushSocialBusinessModule(indexPath.row, animated: true)
                }
            )
        
        compositeDisposable += rac_signalForSelector(Selector("tableView:commitEditingStyle:forRowAtIndexPath:"), fromProtocol: UITableViewDataSource.self).toSignalProducer()
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> map { parameters -> (UITableViewCellEditingStyle, NSIndexPath) in
                let tuple = parameters as! RACTuple
                return (tuple.second as! UITableViewCellEditingStyle, tuple.third as! NSIndexPath)
            }
            |> logLifeCycle(LogContext.Profile, "tableView:commitEditingStyle:forRowAtIndexPath:")
            |> start(
                next: { [weak self] editingStyle, indexPath in
                    if let this = self {
                        if editingStyle == UITableViewCellEditingStyle.Delete {
                            this.viewmodel.undoParticipation(indexPath.row)
                                |> start()
                            this.viewmodel.profileBusinessViewModelArr.value.removeAtIndex(indexPath.row)
                            this.tableView.reloadData()
                        }
                    }
                }
            )
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewmodel.profileBusinessViewModelArr.producer
            |> start(next: { [weak self] _ in
                self?.tableView.reloadData()
            })
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(profileViewModel: IProfileViewModel) {
        viewmodel = profileViewModel
    }
    
    // MARK: - Others
}


/**
*  UITableViewDataSource
*/
extension ProfileViewController : UITableViewDataSource, UITableViewDelegate {
    /**
    Asks the data source to return the number of sections in the table view.
    
    :param: tableView An object representing the table view requesting this information.
    
    :returns: The number of sections in tableView. The default value is 1.
    */
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return numberOfChats
        return viewmodel.profileBusinessViewModelArr.value.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var businessCell = tableView.dequeueReusableCellWithIdentifier(BusinessCellIdentifier, forIndexPath: indexPath) as! ProfileBusinessCell
        businessCell.bindViewModel(viewmodel.profileBusinessViewModelArr.value[indexPath.row])
        
        return businessCell
        
    }
}



/**
*  UITableViewDelegate
*/
extension ProfileViewController : UITableViewDelegate {
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
}