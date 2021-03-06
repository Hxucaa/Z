//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import AVOSCloud
import Dollar
import Cartography

private let HeaderViewHeightRatio = CGFloat(0.30)

public final class ProfileViewController : XUIViewController {

    // MARK: - UI Controls
    
    private let upperViewController = ProfileUpperViewController()
    private let bottomViewController = ProfileBottomViewController()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(frame: CGRectMake(345, 27, 26, 30))
        button.userInteractionEnabled = true
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 2, bottom: 3, right: 2)
        button.setImage(UIImage(named: ImageAssets.editIcon), forState: .Normal)
        
        let editAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { observer, disposable in
                self?.viewmodel.presentProfileEditModule(true, completion: nil)
                observer.sendCompleted()
            }
        }
        
        button.addTarget(editAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        return button
        }()
    
    
    // MARK: - Properties
    private var viewmodel: IProfileViewModel! {
        didSet {
            upperViewController.bindToViewModel(viewmodel.profileUpperViewModel)
            bottomViewController.bindToViewModel(viewmodel.profileBottomViewModel)
        }
    }

    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let selfFrame = self.view.frame
        let viewHeight = round(selfFrame.size.height * 0.30)
        
        upperViewController.view.frame = CGRect(origin: selfFrame.origin, size: CGSizeMake(selfFrame.size.width, viewHeight))
        
        bottomViewController.view.frame = CGRect(origin: CGPointMake(selfFrame.origin.x, viewHeight), size: CGSizeMake(selfFrame.size.width, selfFrame.size.height - viewHeight))
        
        view.userInteractionEnabled = true
        view.opaque = true
        view.backgroundColor = UIColor.grayColor()
        
        addChildViewController(upperViewController)
        addChildViewController(bottomViewController)
        
        view.addSubview(upperViewController.view)
        view.addSubview(bottomViewController.view)
        view.addSubview(editButton)
        
        upperViewController.didMoveToParentViewController(self)
        bottomViewController.didMoveToParentViewController(self)
        
        constrain(upperViewController.view) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.height == $0.superview!.height * 0.30
        }
        
        constrain(upperViewController.view, bottomViewController.view) {
            $1.leading == $1.superview!.leading
            $1.top == $0.bottom
            $1.trailing == $1.superview!.trailing
            $1.bottom == $1.superview!.bottom
        }
        
        constrain(editButton) {
            $0.width == 26
            $0.height == 30
            $0.trailing == $0.superview!.trailingMargin
            $0.top == $0.superview!.top + 25
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
        navigationController?.hidesBarsOnSwipe = false
        
        upperViewController.editProxy
            // forwards events from producer until the view controller is going to disappear
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Profile, signalName: "headerView.editProxy")
            .startWithNext { [weak self] in
                self?.viewmodel.presentProfileEditModule(true, completion: nil)
            }
        
//        bottomViewController.fullImageProxy
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.Profile, signalName: "photoManager.fullImageProxy")
//            .startWithNext { [weak self] in
//                self?.viewmodel.presentFullScreenImageModule(true, completion: nil)
//            }

    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IProfileViewModel) {
        self.viewmodel = viewmodel
    }
    
    // MARK: - Others
}