//
//  FeaturedTabNavigationController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-31.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit
import XAssets
import AMScrollingNavbar

final class FeaturedTabNavigationController : ScrollingNavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        let tab = UITabBarItem(title: "推荐", image: AssetsTabBar.imageOfHomeIcon(false), selectedImage: AssetsTabBar.imageOfHomeIcon(true))
        
        tabBarItem = tab
    }
}