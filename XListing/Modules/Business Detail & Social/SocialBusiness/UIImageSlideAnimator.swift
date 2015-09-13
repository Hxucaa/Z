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

public final class UIImageSlideAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private let startRect: CGRect
    private let destination: CGPoint
    private let image: UIImage
    
    public init(startRect: CGRect, destination: CGPoint, image: UIImage) {
        self.startRect = startRect
        self.destination = destination
        self.image = image
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 2.2
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
        
        // destination view controller is transparent at first
        toView.alpha = 0
        
        let animatingView = UIImageView(image: image)
        animatingView.frame = startRect
        
        // add blur effect
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
                    1.3,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        animatingView.frame.origin = self.destination

                    }) { finished in
                        done()
                    }
            },
            { done in
                UIView.animateWithDuration(
                    0.5,
                    animations: {
                        toView.alpha = 1

                    }) { finished in
                        transitionContext.completeTransition(true)
                        animatingView.removeFromSuperview()
                        fromView.alpha = 1
                        done()
                    }
            }
        ).run()
    }
}
