//
//  ProfileBottomViewController.swift
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


public final class ProfileBottomViewController : UIViewController {
    
    // MARK: - UI Controls
    
    private lazy var pageControls: ButtonPageControl = {
        let view = ButtonPageControl(frame: CGRect(origin: CGPointMake(0, 0), size: self.view.frame.size))
        view.backgroundColor = .whiteColor()
        view.opaque = true
        
        return view
    }()
    
    // MARK: - Properties
    private var viewmodel: IProfileBottomViewModel!
    
    // MARK: - Initializers
    
    // MARK: - Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.opaque = true
        view.backgroundColor = UIColor.grayColor()
        
        view.addSubview(pageControls)
        
        constrain(pageControls) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.height == $0.superview!.height * 0.10
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IProfileBottomViewModel) {
        self.viewmodel = viewmodel
    }
}