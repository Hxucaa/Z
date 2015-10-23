//
//  UIImageSlideAnimator.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import Cartography

private let BusinessHeightRatio = 0.61
private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let ScreenHeight = UIScreen.mainScreen().bounds.size.height

public final class SBtoBDAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private let startRect: CGRect
    private let destination: CGPoint
    private let headerView: SocialBusinessHeaderView
    private let utilityHeaderView: SocialBusiness_UtilityHeaderView
    
    public init(startRect: CGRect, destination: CGPoint, headerView: SocialBusinessHeaderView, utilityHeaderView: SocialBusiness_UtilityHeaderView) {
        self.startRect = startRect
        self.destination = destination
        self.headerView = headerView
        self.utilityHeaderView = utilityHeaderView
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.4
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /// A `UITransitionView` that contains the source and destination views
        let containerView = transitionContext.containerView()
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as! SocialBusinessViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as! BusinessDetailViewController
        
        
        containerView.opaque = true
        containerView.backgroundColor = UIColor.whiteColor()
        
        // destination view controller is transparent at first
        toView.alpha = 0

        headerView.frame = startRect
        if -startRect.origin.y > startRect.height {
            utilityHeaderView.frame = CGRectMake(0, 0, CGFloat(ScreenWidth), 44)
        } else {
            utilityHeaderView.frame = CGRectMake(0, startRect.height+startRect.origin.y, CGFloat(ScreenWidth), 44)
        }
        
        let tableView = toViewController.getAnimationMembers
        tableView.frame = CGRectMake(0, CGFloat(ScreenHeight), CGFloat(ScreenWidth), 600)
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(headerView)
        containerView.addSubview(utilityHeaderView)
        containerView.addSubview(tableView)
        
        // chain animation
        Chain(
            { done in
                UIView.animateWithDuration(
                    0.1,
                    delay: 0.0,
                    options: UIViewAnimationOptions.TransitionNone,
                    animations: {
                        fromView.alpha = 0
                        toViewController.navigationController?.setNavigationBarHidden(true, animated: false)
                    }) { finished in
                        done()
                    }
            },
            { done in
                UIView.animateWithDuration(
                    0.2,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        
                        self.headerView.frame.origin = self.destination
                        self.utilityHeaderView.frame.origin = CGPoint(x:0, y:self.headerView.frame.height+self.headerView.frame.origin.y)
                        tableView.frame.origin = CGPoint(x:0, y:self.utilityHeaderView.frame.height+self.utilityHeaderView.frame.origin.y)
                    }) { finished in
                        done()
                    }
            },
            { done in
                UIView.animateWithDuration(
                    0.1,
                    animations: {
                        toView.alpha = 1

                    }) { finished in
                        transitionContext.completeTransition(true)
                        self.headerView.removeFromSuperview()
                        self.utilityHeaderView.removeFromSuperview()
                        fromView.alpha = 1
                        done()
                    }
            }
        ).run()
    }
}
