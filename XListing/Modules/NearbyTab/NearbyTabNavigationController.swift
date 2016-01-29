//
//  NearbyTabNavigationController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import XAssets
import AMScrollingNavbar

public final class NearbyTabNavigationController : ScrollingNavigationController {
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let tab = UITabBarItem(title: "附近", image: AssetsTabBar.imageOfNearbyIcon(false), selectedImage: AssetsTabBar.imageOfNearbyIcon(true))
        
        tabBarItem = tab
    }
}