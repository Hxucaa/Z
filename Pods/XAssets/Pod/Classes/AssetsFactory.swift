//
//  AssetFactory.swift
//  Pods
//
//  Created by Lance Zhu on 2015-08-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SDWebImage
import ReactiveCocoa

private let CacheNamespace = "org.xassets.XAssets.ImageCache"

public final class AssetFactory {
    
    /// Retrieve the image from cache. If it is not already in the cache, one will be created and stored in cache.
    public class func getImage(asset: Asset) -> SignalProducer<UIImage, NoError> {
//        println("Image generated successfully")
        let key = asset.cacheKey()
        
        return SignalProducer { sink, disposable in
            // cache has to be declared locally to solve a compile time compatibility issue between SDWebImage and ReactiveCocoa
            let cache = SDImageCache(namespace: CacheNamespace)
            
            cache.queryDiskCacheForKey(key) { image, type in
                if image != nil {
                    sendNext(sink, image)
                    sendCompleted(sink)
                }
                else {
                    let image = asset.image()
                    cache.storeImage(image, forKey: key)
                    
                    sendNext(sink, image)
                    sendCompleted(sink)
                }
            }
        }
    }
    
    /// Remove image from memory cache. Optionally remove from disk cache.
    public class func removeImage(asset: Asset, fromDisk: Bool? = true) -> SignalProducer<Void, NoError> {
        return SignalProducer { sink, disposable in
            // cache has to be declared locally to solve a compile time compatibility issue between SDWebImage and ReactiveCocoa
            let cache = SDImageCache(namespace: CacheNamespace)
            cache.removeImageForKey(asset.cacheKey(), fromDisk: fromDisk!) { () -> Void in
                sendNext(sink, ())
                sendCompleted(sink)
            }
        }
    }
    
    /// Clear memory cache.
    public class func clearMemoryCache() {
        let cache = SDImageCache(namespace: CacheNamespace)
        cache.clearMemory()
    }
    
    /// Clear disk cache.
    public class func clearDiskCache() -> SignalProducer<Void, NoError> {
        return SignalProducer { sink, disposable in
            let cache = SDImageCache(namespace: CacheNamespace)
            cache.clearDiskOnCompletion { () -> Void in
                sendNext(sink, ())
                sendCompleted(sink)
            }
        }
    }}
