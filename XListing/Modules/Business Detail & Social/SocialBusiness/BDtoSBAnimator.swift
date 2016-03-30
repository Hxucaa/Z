////
////  BDtoSBAnimator.swift
////  XListing
////
////  Created by Bruce Li on 2015-10-06.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Cartography
//
//private let BusinessHeightRatio = 0.61
//private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
//private let ScreenHeight = UIScreen.mainScreen().bounds.size.height
//
//final class BDtoSBAnimator : NSObject, UIViewControllerAnimatedTransitioning {
//    
//    private let tableView: UITableView
//    private let headerView: SocialBusinessHeaderView
//    private let utilityHeaderView: SocialBusiness_UtilityHeaderView
//    private let headerViewModel: SocialBusinessHeaderViewModel
//    
//    init(tableView: UITableView, headerView: SocialBusinessHeaderView, utilityHeaderView: SocialBusiness_UtilityHeaderView, headerVM: SocialBusinessHeaderViewModel) {
//        self.tableView = tableView
//        self.headerView = headerView
//        self.utilityHeaderView = utilityHeaderView
//        self.headerViewModel = headerVM
//    }
//    
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
//        return 0.4
//    }
//    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        
//        /// A `UITransitionView` that contains the source and destination views
//        let containerView = transitionContext.containerView()!
//        
//        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
//        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
//        
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as! SocialBusinessViewController
//        
//        let headerView = SocialBusinessHeaderView(frame: self.headerView.frame)
//        headerView.bindToViewModel(self.headerViewModel)
//        let utilityHeaderView = SocialBusiness_UtilityHeaderView(frame: self.utilityHeaderView.frame)
//        utilityHeaderView.setDetailInfoButtonStyleSelected()
//        let headerDestinationPoint = toViewController.getHeaderDestinationPoint()
//        
//        containerView.opaque = true
//        containerView.backgroundColor = UIColor.whiteColor()
//        
//        // destination view controller is transparent at first
//        toView.alpha = 0
//        
//        containerView.addSubview(toView)
//        containerView.addSubview(fromView)
//        containerView.addSubview(headerView)
//        containerView.addSubview(utilityHeaderView)
//        containerView.addSubview(tableView)
//        
////        toViewController.navigationController?.setNavigationBarHidden(true, animated: false)
//        
//        // chain animation
//        
//        
//        Chain (
//            { done in
//                UIView.animateWithDuration(
//                    0.1,
//                    delay: 0.0,
//                    options: UIViewAnimationOptions.TransitionNone,
//                    animations: {
//                        fromView.alpha = 0
//                    }) { finished in
//                        utilityHeaderView.setDetailInfoButtonStyleRegular()
//                        done()
//                }
//            },
//            { done in
//                UIView.animateWithDuration(
//                    0.2,
//                    delay: 0.0,
//                    options: UIViewAnimationOptions.CurveEaseInOut,
//                    animations: {
//                        toViewController.navigationController?.setNavigationBarHidden(false, animated: false)
//                        headerView.frame.origin = CGPoint(x:0, y:headerDestinationPoint.y)
//                        
//                        if -headerDestinationPoint.y > headerView.frame.height {
//                            utilityHeaderView.frame.origin = CGPoint(x:0, y:0)
//                        } else {
//                            utilityHeaderView.frame.origin = CGPoint(x:0, y:headerDestinationPoint.y+headerView.frame.height)
//                        }
//                        self.tableView.frame.origin = CGPoint(x:0, y:CGFloat(ScreenHeight))
//                        
//                    }) { finished in
//                        
//                        done()
//                }
//            },
//            { done in
//                UIView.animateWithDuration(
//                    0.1,
//                    animations: {
//                        
//                        
//                    }) { finished in
//                        transitionContext.completeTransition(true)
//                        headerView.removeFromSuperview()
//                        utilityHeaderView.removeFromSuperview()
//                        self.tableView.removeFromSuperview()
//                        toView.alpha = 1
//                        done()
//                        
//                }
//            }
//            ).run()
//    }
//}
