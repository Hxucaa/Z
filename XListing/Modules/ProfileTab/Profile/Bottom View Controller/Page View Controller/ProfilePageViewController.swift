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
    
    // MARK: - Proxies
    private let (_fullImageProxy, _fullImageSink) = SimpleProxy.proxy()
    public var fullImageProxy: SimpleProxy {
        return _fullImageProxy
    }
    
    // MARK: - Initializers
    
    // MARK: - Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.opaque = true
        view.backgroundColor = UIColor.whiteColor()
        
        displayParticipationListPage()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

        photoManagerViewController.fullImageProxy
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Profile, "photoManagerViewController.fullImageProxy")
            |> start(next: { [weak self] in
                if let this = self {
                    proxyNext(this._fullImageSink, ())
                }
            })
        
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