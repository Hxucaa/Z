//
//  DetailViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit
import Realm

public class DetailViewController : UIViewController {
    
    public var detailVM: IDetailViewModel?
    
    public var businessVM: BusinessViewModel?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = businessVM?.nameSChinese
        println(businessVM!)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}