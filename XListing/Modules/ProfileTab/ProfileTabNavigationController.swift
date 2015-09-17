//
//  ProfileTabNavigationController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import XAssets

public final class ProfileTabNavigationController : XBaseUINavigationController {
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let tab = UITabBarItem(title: "个人", image: AssetsTabBar.imageOfProfileIcon(false), selectedImage: AssetsTabBar.imageOfProfileIcon(true))
        
        tabBarItem = tab
    }
}