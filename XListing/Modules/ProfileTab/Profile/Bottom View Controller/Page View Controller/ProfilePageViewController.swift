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
    private lazy var pageDataSource: [UIViewController] = {
        let array = [self.participationListViewController, self.photoManagerViewController]
        
        return array
    }()
    
    private lazy var participationListViewController: ParticipationListViewController = {
        let vc = ParticipationListViewController()
        
        return vc
    }()
    
    private lazy var photoManagerViewController: PhotoManagerViewController = {
        let vc = PhotoManagerViewController()
        
        return vc
    }()
    
    // MARK: - Properties
    private var viewmodel: IProfilePageViewModel! {
        didSet {
            participationListViewController.bindToViewModel(viewmodel.participationListViewModel)
            photoManagerViewController.bindToViewModel(viewmodel.photoManagerViewModel)
        }
    }
    
    private var shouldDisplayCollection = false
    
    // MARK: - Initializers
    
    // MARK: - Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.opaque = true
        view.backgroundColor = UIColor.whiteColor()
        
        dataSource = self
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate = nil
        delegate = self
        
        if (shouldDisplayCollection) {
            displayPhotosManagerPage(animated: true, completion: nil)
        } else {
            displayParticipationListPage(animated: true, completion: nil)
        }
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IProfilePageViewModel) {
        self.viewmodel = viewmodel
    }
    
    // MARK: - API
    
    public func displayParticipationListPage(animated: Bool = false, completion: (Bool -> Void)? = nil) {
        setViewControllers([participationListViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: animated, completion: completion)
    }
    
    public func displayPhotosManagerPage(animated: Bool = false, completion: (Bool -> Void)? = nil) {
        setViewControllers([photoManagerViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: animated, completion: completion)
    }
}

extension ProfilePageViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = $.findIndex(pageDataSource) { $0 === viewController }
        if let index = index where index - 1 >= 0 {
            return pageDataSource[index - 1]
        }
        
        return nil
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = $.findIndex(pageDataSource) { $0 === viewController }
        if let index = index where index + 1 < count(pageDataSource) {
            return pageDataSource[index + 1]
        }
        
        return nil
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        // ensures the page view controller doesn't reset to the participation list after the photo picker is presented
        if (pageViewController.viewControllers[0].className == "XListing.ParticipationListViewController") {
            shouldDisplayCollection = false
        } else {
            shouldDisplayCollection = true
        }
    }
    
}