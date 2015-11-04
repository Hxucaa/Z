//
//  ProfileUpperViewController.swift
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


public final class ProfileUpperViewController : UIViewController {
    
    // MARK: - UI Controls
    
    
    private lazy var headerView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        
        return view
    }()
    
    // MARK: - Proxies
    private let (_editProxy, _editObserver) = SimpleProxy.proxy()
    public var editProxy: SimpleProxy {
        return _editProxy
    }
    
    // MARK: - Properties
    private var viewmodel: IProfileUpperViewModel!
    
    
    // MARK: - Initializers
    
    // MARK: - Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.userInteractionEnabled = true
        view.opaque = true
        view.backgroundColor = UIColor.grayColor()
        
        view.addSubview(headerView)
        
        constrain(headerView) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewmodel.getUserInfo()
            // forwards events from producer until the view controller is going to disappear
            .takeUntilViewWillDisappear(self)
            .start()

        viewmodel.profileHeaderViewModel.producer
            // forwards events from producer until the view controller is going to disappear
            .takeUntilViewWillDisappear(self)
            .ignoreNil
            .start(next: { [weak self] viewmodel in
                self?.headerView.bindToViewModel(viewmodel)
            })
        
        headerView.editProxy
            // forwards events from producer until the view controller is going to disappear
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Profile, "headerView.editProxy")
            .start(next: { [weak self] in
                if let this = self {
                    proxyNext(this._editObserver, ())
                }
            })
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IProfileUpperViewModel) {
        self.viewmodel = viewmodel
    }
}