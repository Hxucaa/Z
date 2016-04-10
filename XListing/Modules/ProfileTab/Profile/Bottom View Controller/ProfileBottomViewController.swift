//
//  ProfileBottomViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import XLPagerTabStrip

private let PageControlHeightRatio = CGFloat(0.08)

final class ProfileBottomViewController : ButtonBarPagerTabStripViewController {
    // MARK: - UI Controls
//    private lazy var pageControls: ProfileSegmentControlView = {
//        let view = ProfileSegmentControlView(frame: CGRect(origin: CGPointMake(0, 0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height * PageControlHeightRatio)))
//        view.backgroundColor = .whiteColor()
//        view.opaque = true
//        return view
//    }()
//    
//    private lazy var pageViewController: ProfilePageViewController = {
//        let vc = ProfilePageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
//        return vc
//    }()
    var participationListViewController: ParticipationListViewController!
    var photoManagerViewController: PhotoManagerViewController!

    
    // MARK: - Properties
//    private var viewmodel: IProfileBottomViewModel! {
//        didSet {
//            pageViewController.bindToViewModel(viewmodel.profilePageViewModel)
//        }
//    }
    
    // MARK: - Initializers
    
    // MARK: - Setups
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .whiteColor()
        settings.style.buttonBarItemBackgroundColor = .whiteColor()
        settings.style.selectedBarBackgroundColor = UIColor.x_PrimaryColor()
        settings.style.buttonBarItemFont = .boldSystemFontOfSize(14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .blackColor()
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        containerView.backgroundColor = .whiteColor()
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .blackColor()
            newCell?.label.textColor = UIColor.x_PrimaryColor()
        }
        
        super.viewDidLoad()
        
        view.opaque = true
        view.backgroundColor = .whiteColor()
        
//        view.addSubview(pageControls)
//        
//        addChildViewController(pageViewController)
//        view.addSubview(pageViewController.view)
//        pageViewController.didMoveToParentViewController(self)
//        
//        constrain(pageControls) {
//            $0.leading == $0.superview!.leading
//            $0.top == $0.superview!.top
//            $0.trailing == $0.superview!.trailing
//            $0.height == $0.superview!.height * PageControlHeightRatio
//        }
//        
//        constrain(pageControls, pageViewController.view) {
//            $1.leading == $1.superview!.leading
//            $1.top == $0.bottom
//            $1.trailing == $1.superview!.trailing
//            $1.bottom == $1.superview!.bottom
//        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
//        pageControls.participationListProxy
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.Profile, signalName: "pageControls.participationListProxy")
//            .startWithNext { [weak self] in
//                self?.pageViewController.displayParticipationListPage()
//            }
//        
////        pageControls.photosManagerProxy
////            .takeUntilViewWillDisappear(self)
////            .logLifeCycle(LogContext.Profile, signalName: "pageControls.photosManagerProxy")
////            .startWithNext { [weak self] in
////                self?.pageViewController.displayPhotosManagerPage()
////            }
//        
////        pageViewController.fullImageProxy
////            // forwards events from producer until the view controller is going to disappear
////            .takeUntilViewWillDisappear(self)
////            .logLifeCycle(LogContext.Profile, signalName: "pageViewController.fullImageProxy")
////            .startWithNext { [weak self] in
////                if let this = self {
////                    this._fullImageObserver.proxyNext(())
////                }
////            }
        
    }
    
    // MARK: - Bindings
    
    func bindToViewModel() {
//        self.viewmodel = viewmodel
    }
    
    // MARK: - Others
//    func animateSegmentControl(index: Int){
//        pageControls.animate(toIndex: index, duration: 0.1);
//    }
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [participationListViewController, photoManagerViewController]
    }
}