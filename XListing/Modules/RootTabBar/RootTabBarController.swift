//
//  RootTabBarController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-01.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit
//import ReactiveCocoa
import RxSwift
import RxOptional

final class RootTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    
    var selectedViewControllerCallback: (UIViewController -> ())?
    var meRepository: IMeRepository!
    weak var router: IRouter!
    
    private let disposeBag = DisposeBag()
//    private weak var activeNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.x_PrimaryColor()
        tabBar.translucent = false
        delegate = self
        
        self.rx_observe(UIViewController.self, "selectedViewController").asObservable()
            .filterNil()
            .subscribeNext { self.selectedViewControllerCallback?($0) }
            .addDisposableTo(disposeBag)
//        DynamicProperty(object: self, keyPath: "selectedViewController").producer
//            .ignoreNil()
//            .map { $0 as! UIViewController }
//            .startWithNext { [unowned self] in
//                if let f = self.selectedViewControllerCallback {
//                    f($0)
//                }
//            }
        
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        // FIXME: enable the code below
        if viewController is ProfileTabNavigationController {
            // if user is logged in already, continue on
            if meRepository.me() != nil {
                return true
            }
                // else make the user log in / sign up first
            else {
                router.accountFinishedCallback = { [weak self] in
                    if self?.meRepository.me() != nil {
                        self?.selectedViewController = viewController
                    }
                }
                router.presentAccountOnTabView(nil)
                return false
            }
        }
//        if let nav = viewController as? FeaturedTabNavigationController {
//            activeNavigationController = nav
//            return true
//        }
        
        return true
    }
}
