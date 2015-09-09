//
//  SocialBusinessViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveArray
import Dollar
import Cartography

private let UserCellIdentifier = "SocialBusiness_UserCell"
private let BusinessCellIdentifier = "SocialBusiness_BusinessCell"
private let userControllerIdentifier = "UserProfileViewController"
private let BusinessHeightRatio = 0.61
private let UserHeightRatio = 0.224
private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let WTGBarHeight = CGFloat(70)

public final class SocialBusinessViewController : XUIViewController {
    
    // MARK: - UI Controls
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, 600, 600), style: UITableViewStyle.Plain)
        tableView.showsHorizontalScrollIndicator = false
        tableView.opaque = true
        
        return tableView
    }()
    @IBOutlet private weak var infoButton: UIButton!
    @IBOutlet private weak var startEventButton: UIButton!
    private let headerView = SocialBusiness_HeaderView(frame: CGRectMake(0, 0, 600, CGFloat(ScreenWidth) * CGFloat(BusinessHeightRatio)))
    
    // MARK: - Properties
    private var viewmodel: ISocialBusinessViewModel!

    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        constrain(tableView) { view in
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
        }
        
        tableView.tableHeaderView = headerView
        
        tableView.registerClass(SocialBusiness_UserCell.self, forCellReuseIdentifier: UserCellIdentifier)
        tableView.rowHeight = CGFloat(ScreenWidth) * CGFloat(UserHeightRatio)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: ISocialBusinessViewModel) {
        self.viewmodel = viewmodel
        
    }
    
    // MARK: - Others
}

extension SocialBusinessViewController: UITableViewDelegate, UITableViewDataSource{
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    public func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(UserCellIdentifier) as!
        SocialBusiness_UserCell
        return cell
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, CGFloat(ScreenWidth), WTGBarHeight))
        let bar = NSBundle.mainBundle().loadNibNamed("SocialBusiness_UtilityView", owner: self, options:nil)[0] as? UIView
        bar?.frame = CGRectMake(0, 0, CGFloat(ScreenWidth), WTGBarHeight)
        if let bar = bar {
            view.addSubview(bar)
        }
        return view
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return WTGBarHeight
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "UserProfile", bundle: nil)
        if let controller = storyboard.instantiateViewControllerWithIdentifier(userControllerIdentifier) as? UserProfileViewController {
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}