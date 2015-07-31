//
//  ImageService.swift
//  XListing
//
//  Created by William Qi on 2015-07-14.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SDWebImage
import ReactiveCocoa

public final class ImageService : IImageService {
    public func getImage(url: NSURL) -> SignalProducer<UIImage, NSError> {
        return SignalProducer { sink, disposable in
            let imageManager = SDWebImageManager.sharedManager()
            imageManager.downloadImageWithURL(url, options: SDWebImageOptions.ContinueInBackground, progress: nil, completed: {(image:UIImage!, error:NSError!, cacheType:SDImageCacheType, finished:Bool, url:NSURL!) in
                if (error == nil) {
                    sendNext(sink, image)
                    sendCompleted(sink)
                } else {
                    sendError(sink, error)
                }
            })
        }
        
    }
}

