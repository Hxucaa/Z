//
//  ImageService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-14.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SDWebImage
import ReactiveCocoa
import AVOSCloud

public final class ImageService : IImageService {
    
    public func getImageBy(url: NSURL) -> SignalProducer<UIImage, NSError> {
        return SignalProducer { observer, disposable in
            let imageManager = SDWebImageManager.sharedManager()
            imageManager.downloadImageWithURL(url, options: SDWebImageOptions.ContinueInBackground, progress: nil, completed: { image, error, cache, finished, url in
                if error == nil {
                    observer.sendNext(image)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            })
        }
        
    }
    
    public func getImage(image: ImageFile) -> SignalProducer<UIImage, NSError> {
        return SignalProducer { observer, disposable in
            
            let imageManager = SDWebImageManager.sharedManager()
            guard let nsurl = NSURL(string: image.url) else {
                observer.sendFailed(NSError(domain: "XListing.ImageService", code: 999, userInfo: ["message" : "Invalid url"]))
                return
            }
            
            imageManager.downloadImageWithURL(nsurl, options: SDWebImageOptions.ContinueInBackground, progress: nil, completed: { image, error, cache, finished, url -> Void in
                if error == nil {
                    observer.sendNext(image)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            })
        }
    }
    
    public func getThumbnail(image: ImageFile, thumbnailSize: Thumbnail.Dimension) -> SignalProducer<Thumbnail, NSError> {
        return SignalProducer { observer, disposable in
            
            let dimension = thumbnailSize.value
            
            let image = AVFile(URL: image.url)
            let url = image.getThumbnailURLWithScaleToFit(dimension.scaleToFit, width: dimension.width, height: dimension.height, quality: dimension.quality, format: dimension.format)
            
            guard let nsurl = NSURL(string: url) else {
                observer.sendFailed(NSError(domain: "XListing.ImageService", code: 999, userInfo: ["message" : "Invalid url"]))
                return
            }
            
            let imageManager = SDWebImageManager.sharedManager()
            imageManager.downloadImageWithURL(nsurl, options: SDWebImageOptions.ContinueInBackground, progress: nil, completed: { image, error, cache, finished, url in
                if error == nil {
                    observer.sendNext(image as! Thumbnail)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            })
        }
    }
}

