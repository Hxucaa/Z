//
//  SignInViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public final class AccountViewController: UIViewController {
    
    private var viewmodel: IAccountViewModel!
    
    public func bindToViewModel(viewModel: IAccountViewModel) {
        self.viewmodel = viewModel
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
