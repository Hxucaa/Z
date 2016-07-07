//
//  ImageService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-14.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import SDWebImage
import AVOSCloud
import RxSwift

public final class ImageService : IImageService {
    
    public func getThumbnail(image: ImageFile, thumbnailSize: Thumbnail.Dimension) -> Observable<Thumbnail> {
        return Observable.create { observer in
            
            let dimension = thumbnailSize.value
            
            let image = AVFile(URL: image.url?.absoluteString)
            let url = image.getThumbnailURLWithScaleToFit(dimension.scaleToFit, width: dimension.width, height: dimension.height, quality: dimension.quality, format: dimension.format)
            
            guard let nsurl = NSURL(string: url) else {
                observer.onError(NSError(domain: "XListing.ImageService", code: 999, userInfo: ["message" : "Invalid url"]))
                return NopDisposable.instance
            }
            
            let imageManager = SDWebImageManager.sharedManager()
            let download = imageManager.downloadImageWithURL(nsurl, options: SDWebImageOptions.ContinueInBackground, progress: nil, completed: { image, error, cache, finished, url in
                if error == nil {
                    observer.onNext(image as! Thumbnail)
                    observer.onCompleted()
                }
                else {
                    observer.onError(error)
                }
            })
            
            return AnonymousDisposable {
                download.cancel()
            }
        }
    }
    
    public func getImage(image: ImageFile) -> Observable<UIImage> {
        return Observable.create { observer in
            
            let imageManager = SDWebImageManager.sharedManager()
            guard let url = image.url else {
                observer.onError(NSError(domain: "XListing.ImageService", code: 999, userInfo: ["message" : "Invalid url"]))
                return NopDisposable.instance
            }
            
            let download = imageManager.downloadImageWithURL(url, options: SDWebImageOptions.ContinueInBackground, progress: nil, completed: { image, error, cache, finished, url -> Void in
                if error == nil {
                    observer.onNext(image)
                    observer.onCompleted()
                }
                else {
                    observer.onError(error)
                }
            })
            
            return AnonymousDisposable {
                download.cancel()
            }
        }
    }
    
    public func getImage(url: NSURL) -> Observable<UIImage> {
        return Observable.create { observer in
            let imageManager = SDWebImageManager.sharedManager()
            let download = imageManager.downloadImageWithURL(url, options: SDWebImageOptions.ContinueInBackground, progress: nil, completed: { image, error, cache, finished, url in
                if error == nil {
                    observer.onNext(image)
                    observer.onCompleted()
                }
                else {
                    observer.onError(error)
                }
            })
            
            return AnonymousDisposable {
                download.cancel()
            }
        }
    }
}

