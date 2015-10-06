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

public final class UIImageSlideAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private let startRect: CGRect
    private let destination: CGPoint
    //private let headerView: SocialBusinessHeaderView
    
    public init(startRect: CGRect, destination: CGPoint, headerView: SocialBusinessHeaderView) {
        self.startRect = startRect
        self.destination = destination
        //self.headerView = headerView
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 2.7
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
        
        let (headerView, utilityHeaderView) = fromViewController.getAnimationMembers
        headerView.frame = startRect
        utilityHeaderView.frame = CGRectMake(0, startRect.height+startRect.origin.y, CGFloat(ScreenWidth), 44)
        
        
        //let tableView = toViewController.getAnimationMembers
        let tableView = BusinessDetailTableView(frame: CGRectMake(0, CGFloat(ScreenHeight), CGFloat(ScreenWidth), 600), style: UITableViewStyle.Grouped)
        tableView.frame = CGRectMake(0, CGFloat(ScreenHeight), CGFloat(ScreenWidth), 600)
        
        // add blur effect
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = headerView.frame
        
        headerView.addSubview(effectView)
        
        constrain(effectView) { view in
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
        }
        
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
                    delay: 0.2,
                    options: UIViewAnimationOptions.TransitionNone,
                    animations: {
                        fromView.alpha = 0
                    }) { finished in
                        done()
                    }
            },
            { done in
                UIView.animateWithDuration(
                    0.7,
                    animations: { () -> Void in
                        effectView.alpha = 0
                    },
                    completion: { finished in
                        done()
                    })
            },
            { done in
                UIView.animateWithDuration(
                    1.3,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        headerView.frame.origin = self.destination
                        utilityHeaderView.frame.origin = CGPoint(x:0, y:headerView.frame.height+headerView.frame.origin.y)
                        tableView.frame.origin = CGPoint(x:0, y:utilityHeaderView.frame.height+utilityHeaderView.frame.origin.y)
                    }) { finished in
                        done()
                    }
            },
            { done in
                UIView.animateWithDuration(
                    0.3,
                    animations: {
                        toView.alpha = 1

                    }) { finished in
                        transitionContext.completeTransition(true)
                        headerView.removeFromSuperview()
                        utilityHeaderView.removeFromSuperview()
                        tableView.removeFromSuperview()
                        fromView.alpha = 1
                        done()
                    }
            }
        ).run()
    }
}
