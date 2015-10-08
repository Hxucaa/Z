//
//  ProfilePageViewController.swift
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

public final class ProfilePageViewController : UIPageViewController {
    
    // MARK: - UI Controls
//    private lazy var
    
    // MARK: - Properties
    private var viewmodel: IProfileBottomViewModel!
    
    // MARK: - Initializers
    
    // MARK: - Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.opaque = true
        view.backgroundColor = UIColor.whiteColor()
        
//        dataSource = self
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        delegate = nil
//        delegate = self
    }
}

//extension ProfilePageViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    
//    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//    
//    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//}