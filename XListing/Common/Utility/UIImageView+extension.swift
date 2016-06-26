//
//  UIImageView+extension.swift
//  XListing
//
//  Created by William Qi on 2015-07-16.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func setImageWithAnimation(image: UIImage) {
        UIView.transitionWithView(
            self,
            duration: 1.0,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: {() -> Void in
                self.image = image
                self.alpha = 1
            },
            completion: nil
        )
    }
}
