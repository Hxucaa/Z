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

public final class SocialBusinessViewController : UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var startEventButton: UIButton!
    
    // MARK: - Properties
    private var viewmodel: ISocialBusinessViewModel!
    private let userCellIdentifier = "usercell"
    private let businessCellIdentifier = "businesscell"
    private let businessHeightRatio = 0.6
    private let userHeightRatio = 0.25
    private let WTGBarHeight = CGFloat(70)
    let screenWidth = UIScreen.mainScreen().bounds.size.width

    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: ISocialBusinessViewModel) {
        self.viewmodel = viewmodel
        
    }
    
    // MARK: - Others
    override public func viewDidLoad() {
        super.viewDidLoad()
        let userNib = UINib(nibName: "BusinessSocialUserCell", bundle: nil)
        let businessNib = UINib(nibName: "BusinessSocialBusinessCell", bundle: nil)
        tableView.registerNib(userNib, forCellReuseIdentifier: userCellIdentifier)
        tableView.registerNib(businessNib, forCellReuseIdentifier: businessCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension SocialBusinessViewController: UITableViewDelegate, UITableViewDataSource{
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch(section){
        case 0: return 1
        case 1: return 10
        default: return 0
        }
    }
    
    public func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            switch(indexPath.section){
            case 0: var cell = tableView.dequeueReusableCellWithIdentifier(businessCellIdentifier) as! BusinessCell
                cell.frame = CGRectMake(0, 0, CGFloat(screenWidth), CGFloat(screenWidth) * CGFloat(businessHeightRatio))
                return cell
            default: var cell = tableView.dequeueReusableCellWithIdentifier(userCellIdentifier) as!
                UserCell
                cell.frame = CGRectMake(0, 0, CGFloat(screenWidth), CGFloat(screenWidth) * CGFloat(userHeightRatio))
                return cell
            }
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath
        indexPath: NSIndexPath) -> CGFloat{
        switch(indexPath.section){
        case 0: return CGFloat(screenWidth) * CGFloat(businessHeightRatio)
        default: return CGFloat(screenWidth) * CGFloat(userHeightRatio)
        }
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        var view: UIView?
        if section == 0{
            view = NSBundle.mainBundle().loadNibNamed("WTGBar", owner: self, options: nil)[0] as? UIView
            view?.frame = CGRectMake(0, 0, CGFloat(screenWidth), WTGBarHeight)
        }
        return view
    }
        
}