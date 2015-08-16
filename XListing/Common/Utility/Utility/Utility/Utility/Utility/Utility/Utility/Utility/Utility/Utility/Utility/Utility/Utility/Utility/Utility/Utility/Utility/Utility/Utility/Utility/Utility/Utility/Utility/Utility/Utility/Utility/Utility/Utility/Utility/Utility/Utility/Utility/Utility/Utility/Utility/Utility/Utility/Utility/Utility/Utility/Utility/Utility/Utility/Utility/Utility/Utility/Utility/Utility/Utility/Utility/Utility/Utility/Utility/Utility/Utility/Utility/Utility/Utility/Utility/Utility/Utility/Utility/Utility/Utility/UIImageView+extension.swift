//
//  UIImageView+extension.swift
//  XListing
//
//  Created by William Qi on 2015-07-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func setImageWithAnimation(image: UIImage) {
        // animation currently disabled due to transition bug
        
//        UIView.transitionWithView(self, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {() -> Void in
            self.image = image
//            self.alpha = 1}
//            , completion: nil)
    }
    
    public func toCircle(){
            let imgWidth = CGFloat(self.frame.width)
            self.layer.cornerRadius = imgWidth / 2
            self.layer.masksToBounds = true;
    }
}
