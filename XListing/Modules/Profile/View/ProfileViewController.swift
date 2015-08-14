//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import AVOSCloud
import Dollar

private let ProfileEditViewControllerIdentifier = "ProfileEditViewController"
private let ProfileStoryBoardName = "Profile"

public final class ProfileViewController : XUIViewController {

    // MARK: - UI Controls
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var tabView: UIView!
    private var headerViewContent: ProfileHeaderView!
    
    // MARK: - Properties
    private var profileVM: ProfileViewModel!
    private var firstSegSelected = true
    private var selectedBusinessChoiceIndex = 0
    private let compositeDisposable = CompositeDisposable()

    // MARK: - Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "个人"
        
        headerViewContent = NSBundle.mainBundle().loadNibNamed("ProfileHeaderView", owner: self, options: nil).first as! ProfileHeaderView
        headerViewContent.frame = CGRectMake(0, 0, headerView.frame.width, headerView.frame.height)
        headerView.addSubview(headerViewContent)
        
        profileVM.profileHeaderViewModel.producer
            |> ignoreNil
            |> start(next: { [weak self] viewmodel in
                self?.headerViewContent.bindViewModel(viewmodel)
            })
        
        let tabViewContent = NSBundle.mainBundle().loadNibNamed("ProfileTabView", owner: self, options: nil).first as! ProfileTabView
        tabView.addSubview(tabViewContent)
        
        let nib = UINib(nibName: "ProfileBusinessCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "BusinessCell")
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = true // for navigation bar hide
        UIApplication.sharedApplication().statusBarHidden=false
        
        willAppearTableView()
        
        compositeDisposable += headerViewContent.backProxy
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Profile, "headerViewContent.backProxy")
            |> start(
                next: { [weak self] in
                    self?.navigationController?.popViewControllerAnimated(true)
                }
            )
        
        compositeDisposable += headerViewContent.editProxy
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Profile, "headerViewContent.editProxy")
            |> start(
                next: { [weak self] in
                    self!.profileVM.presentProfileEditModule()
                }
            )
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.hidden = false
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
                    self?.profileVM.pushDetailModule(indexPath.row)
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
                            this.profileVM.undoParticipation(indexPath.row)
                                |> start()
                            this.profileVM.profileBusinessViewModelArr.value.removeAtIndex(indexPath.row)
                            this.tableView.reloadData()
                        }
                    }
                }
            )
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        profileVM.profileBusinessViewModelArr.producer
            |> start(next: { [weak self] _ in
                self?.tableView.reloadData()
            })
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(profileViewModel: ProfileViewModel) {
        profileVM = profileViewModel
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
        return profileVM.profileBusinessViewModelArr.value.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var businessCell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! ProfileBusinessCell
        businessCell.bindViewModel(profileVM.profileBusinessViewModelArr.value[indexPath.row])
        
        return businessCell
        
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row){
            default: return 90
        }
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