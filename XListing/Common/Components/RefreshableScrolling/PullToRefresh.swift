//
//  PullToRefresh.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import INSPullToRefresh

public final class PullToRefresh : UIView {
    
    private let activityIndicator: UIActivityIndicatorView
    private let imageView: UIImageView
    
    public override init(frame: CGRect) {
        activityIndicator = UIActivityIndicatorView(frame: frame)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.hidden = true
        
        imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: ImageAssets.pullToRefreshArrow)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.opaque = true
        imageView.hidden = false
        
        super.init(frame: frame)
        
        addSubview(activityIndicator)
        addSubview(imageView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        center = CGPointMake(CGRectGetMidX(superview!.bounds), CGRectGetMidY(superview!.bounds))
    }
}

extension PullToRefresh : INSPullToRefreshBackgroundViewDelegate {
    
    public func pullToRefreshBackgroundView(pullToRefreshBackgroundView: INSPullToRefreshBackgroundView!, didChangeState state: INSPullToRefreshBackgroundViewState) {
        if pullToRefreshBackgroundView.state == INSPullToRefreshBackgroundViewState.None {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                self.activityIndicator.alpha = 0.0
                }, completion: nil)
        }
        else {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                self.imageView.alpha = 0.0
                self.activityIndicator.alpha = 1.0
                }, completion: nil)
            self.activityIndicator.startAnimating()
        }
    }
    
    public func pullToRefreshBackgroundView(pullToRefreshBackgroundView: INSPullToRefreshBackgroundView!, didChangeTriggerStateProgress progress: CGFloat) {
        if progress > 0 && pullToRefreshBackgroundView.state == INSPullToRefreshBackgroundViewState.None {
            imageView.alpha = 1.0
        }
    }
}