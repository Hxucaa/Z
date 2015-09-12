//
//  UIImageSlideAnimator.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography

public final class UIImageSlideAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private var startRect: CGRect
    private var destination: CGPoint
    
    public init(startRect: CGRect, destination: CGPoint) {
        self.startRect = startRect
        self.destination = destination
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 2.0
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /// A `UITransitionView` that contains the source and destination views
        let containerView = transitionContext.containerView()
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        
        containerView.opaque = true
        containerView.backgroundColor = UIColor.whiteColor()
        
        // transparent at first
        toView.alpha = 0
        
        let animatingView = UIImageView(image: UIImage(named: ImageAssets.logo))
        animatingView.frame = startRect
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = animatingView.frame
        
        animatingView.addSubview(effectView)
        
        constrain(effectView) { view in
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
        }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(animatingView)
        
        UIView.animateWithDuration(
            1.0,
            delay: 0.2,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: { () -> Void in
                fromView.alpha = 0
                animatingView.frame.origin = self.destination
            
            }) { (finished) -> Void in
                
                animatingView.removeFromSuperview()
                UIView.animateWithDuration(
                    0.5,
                    animations: {
                        toView.alpha = 1
                    
                    }) { finished in
                        transitionContext.completeTransition(true)
                        fromView.alpha = 1
                }
        }
        
    }
}