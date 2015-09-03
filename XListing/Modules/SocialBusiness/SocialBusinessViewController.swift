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
    
    // MARK: - Properties
    private var viewmodel: ISocialBusinessViewModel!
    private let userCellIdentifier = "usercell"
    private let businessCellIdentifier = "businesscell"
    
    
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
        case 1: return 1
        default: return 0
        }
    }
    
    public func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            switch(indexPath.section){
            case 0: var cell = tableView.dequeueReusableCellWithIdentifier(userCellIdentifier) as! UserCell
                return cell
            default: var cell = tableView.dequeueReusableCellWithIdentifier(businessCellIdentifier) as! BusinessCell
                return cell
            }
    }
        
}