//
//  ReverseSideAnimator.swift
//  XListing
//
//  Created by Bruce Li on 2015-10-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import Cartography

private let BusinessHeightRatio = 0.61
private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let ScreenHeight = UIScreen.mainScreen().bounds.size.height

public final class ReverseSlideAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private let tableView: UITableView
    private let headerView: SocialBusinessHeaderView
    private let utilityHeaderView: SocialBusiness_UtilityHeaderView
    
    public init(tableView: UITableView, headerView: SocialBusinessHeaderView, utilityHeaderView: SocialBusiness_UtilityHeaderView) {
        self.tableView = tableView
        self.headerView = headerView
        self.utilityHeaderView = utilityHeaderView
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.2
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /// A `UITransitionView` that contains the source and destination views
        let containerView = transitionContext.containerView()
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as! BusinessDetailViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as! SocialBusinessViewController
        
        let headerView = SocialBusinessHeaderView(frame: self.headerView.frame)
        let utilityHeaderView = SocialBusiness_UtilityHeaderView(frame: self.utilityHeaderView.frame)
        
        containerView.opaque = true
        containerView.backgroundColor = UIColor.whiteColor()
        
        // destination view controller is transparent at first
        toView.alpha = 0
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(headerView)
        containerView.addSubview(utilityHeaderView)
        containerView.addSubview(tableView)
        
        // chain animation
        Chain(
            { done in
                UIView.animateWithDuration(
                    0.2,
                    delay: 0.0,
                    options: UIViewAnimationOptions.TransitionNone,
                    animations: {
                        fromView.alpha = 0
                    }) { finished in
                        done()
                }
            },
            { done in
                UIView.animateWithDuration(
                    0.8,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        headerView.frame.origin = CGPoint(x:0, y:-headerView.frame.height)
                        utilityHeaderView.frame.origin = CGPoint(x:0, y:-utilityHeaderView.frame.height)
                        self.tableView.frame.origin = CGPoint(x:0, y:CGFloat(ScreenHeight))
                    }) { finished in
                        done()
                }
            },
            { done in
                UIView.animateWithDuration(
                    0.2,
                    animations: {
                        toView.alpha = 1
                        
                    }) { finished in
                        transitionContext.completeTransition(true)
                        headerView.removeFromSuperview()
                        utilityHeaderView.removeFromSuperview()
                        self.tableView.removeFromSuperview()
                        toViewController.navigationController?.setNavigationBarHidden(false, animated: true)
                        fromView.alpha = 1
                        done()
                }
            }
            ).run()
    }
}
