//
//  BusinessDetailViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveArray
import Dollar
import Cartography

public final class BusinessDetailViewController : XUIViewController {
    
    // MARK: - UI Controls
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, 600, 600), style: UITableViewStyle.Grouped)
        
        return tableView
    }()
    
    // MARK: - Properties
    private var viewmodel: IBusinessDetailViewModel!
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.opaque = true
        view.backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IBusinessDetailViewModel) {
        self.viewmodel = viewmodel
    }
    
    // MARK: - Others
}