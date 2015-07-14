//
//  ImageUtils.swift
//  XListing
//
//  Created by William Qi on 2015-07-14.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SDWebImage

public struct ImageUtils {
    static public func setSDWebImageWithAnimation(imageView: UIImageView, imageURL: NSURL?, placeholder: UIImage)
    {
        imageView.image = placeholder
        SDWebImageManager.sharedManager().downloadImageWithURL(imageURL, options: nil, progress: nil) { (downloadedImage:UIImage!, error:NSError!, cacheType:SDImageCacheType, isDownloaded:Bool, withURL:NSURL!) -> Void in
            UIView.transitionWithView(imageView, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                imageView.image = downloadedImage
                imageView.alpha = 1
                }, completion: nil)
            
        }
    }
}