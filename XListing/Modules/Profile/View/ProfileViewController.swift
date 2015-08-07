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

    // MARK: UI control
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var tabView: UIView!
    
    // MARK: Property
    
    var headerViewContent: ProfileHeaderView!
    private var profileVM: ProfileViewModel!
    private var firstSegSelected = true
    private var selectedBusinessChoiceIndex = 0

    // MARK: View initilization
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "个人"
        if let temp = NSBundle.mainBundle().loadNibNamed("ProfileHeaderView", owner: self, options: nil)[0] as? ProfileHeaderView{
            headerViewContent  = temp
            headerViewContent.frame = CGRectMake(0, 0, headerView.frame.width, headerView.frame.height)
            headerView.addSubview(headerViewContent)
            self.setupBackButton(headerViewContent.topLeftButton)
            self.setupEditButton(headerViewContent.topRightButton)
        }
        if let tabViewContent = NSBundle.mainBundle().loadNibNamed("ProfileTabView", owner: self, options: nil)[0] as? ProfileTabView{
            tabView.addSubview(tabViewContent)
        }
        self.setupTableView()
        self.setupHeaderView()
    }
    
    // Set up headerViews
    private func tryBindHeaderViewModel() {
        if headerViewContent != nil && self.profileVM!.profileHeaderViewModel.value != nil{
            headerViewContent.bindViewModel(self.profileVM!.profileHeaderViewModel.value!)
        }
        else{
        }
    }
    
    private func setupHeaderView() {
        self.profileVM.profileHeaderViewModel.producer
            |> start(next: { [weak self] _ in
                self!.tryBindHeaderViewModel()
                })
    }
    
    
    // Set up buttons
    private lazy var setupButtons: SignalProducer<Void, NoError> = SignalProducer<Void, NoError> { [weak self] sink, compositeDisposable in
        if self != nil{
        if let view = self!.headerViewContent{
            compositeDisposable += view.backProxy
                |> logLifeCycle(LogContext.Profile, "backproxy")
                |> start(next: {
                    self?.navigationController?.popViewControllerAnimated(true)
                    sendCompleted(sink)
                })
            
            compositeDisposable += view.editProxy
                |> logLifeCycle(LogContext.Profile, "editproxy")
                |> start(next: {
                    let storyboard = UIStoryboard(name: ProfileStoryBoardName, bundle: nil)
                    let viewController = storyboard.instantiateViewControllerWithIdentifier(ProfileEditViewControllerIdentifier) as! ProfileEditViewController
                    let editVM = self?.profileVM.profileEditViewModel
                    viewController.bindToViewModel(editVM!)
                    self?.navigationController?.pushViewController(viewController, animated: true)
                    sendCompleted(sink)
                })
            }
            }
        }
    |> logLifeCycle(LogContext.Profile, "profilepage")
    
    
    private func setupTableView() {
        var nib = UINib(nibName: "ProfileBusinessCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "BusinessCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.profileVM.profileBusinessViewModelArr.producer
            |> start(next: { [weak self] _ in
                self?.tableView.reloadData()
                })
    }
    

    public override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = true // for navigation bar hide
        UIApplication.sharedApplication().statusBarHidden=false
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func bindToViewModel(profileViewModel: ProfileViewModel) {
        profileVM = profileViewModel
        
        
    }
    

    private func setupBackButton(btn: UIButton) {
        let dismissAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer<Void, NoError> { [weak self] sink, disposable in
                self?.navigationController?.popViewControllerAnimated(true)
                sendCompleted(sink)
            }
        }
        btn.addTarget(dismissAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchDown)
    }
    
    private func setupEditButton(btn: UIButton) {
        let editAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer<Void, NoError> { [weak self] sink, disposable in
                let storyboard = UIStoryboard(name: ProfileStoryBoardName, bundle: nil)
                let viewController = storyboard.instantiateViewControllerWithIdentifier(ProfileEditViewControllerIdentifier) as! ProfileEditViewController
                let editVM = self?.profileVM.profileEditViewModel
                viewController.bindToViewModel(editVM!)
                self?.navigationController?.pushViewController(viewController, animated: true)
                sendCompleted(sink)
            }
        }
        btn.addTarget(editAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchDown)
    }
    
    public func bindViewModel(viewmodel: ProfileViewModel) {
        self.profileVM = viewmodel
    }
    
    
    public func changeParticipation (sender:UIButton) {
        var buttonFrame = sender.convertRect(sender.bounds, toView: self.tableView)
        var indexPath = self.tableView.indexPathForRowAtPoint(buttonFrame.origin)
        self.selectedBusinessChoiceIndex = indexPath!.row
        self.presentPopover()
    }
    
    public func presentPopover () {
        var popover = ParticipationPopover()
        popover.delegate = self
        var alert: (UIAlertController) = popover.createPopover()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
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
        var businessCell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as? ProfileBusinessCell
        if businessCell == nil {
            businessCell = NSBundle.mainBundle().loadNibNamed("ProfileBusinessCell", owner: self, options: nil)[0] as? ProfileBusinessCell
        }
        
        businessCell!.bindViewModel(profileVM.profileBusinessViewModelArr.value[indexPath.row])
        
        
        return businessCell!
        
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
    /**
    Tells the delegate that the specified row is now selected.
    
    :param: tableView A table-view object informing the delegate about the new row selection.
    :param: indexPath An index path locating the new selected row in tableView.
    */
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    
    // MARK: delete cells
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            profileVM.undoParticipation(indexPath.row)
                |> start()
            profileVM.profileBusinessViewModelArr.value.removeAtIndex(indexPath.row);
//          [self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)]
            self.tableView.reloadData()
        }
        
    }
}


extension ProfileViewController : ParticipationPopoverDelegate {
    //switch the participation icon based on the selection from the popover
    public func alertAction(choiceTag: Int) {
        self.tableView.reloadData()
    }
}