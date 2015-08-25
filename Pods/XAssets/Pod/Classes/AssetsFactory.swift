//
//  AssetFactory.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SDWebImage
import XAssets
import ReactiveCocoa

public final class AssetFactory {
    
    public class func getImage(asset: Asset) -> SignalProducer<UIImage, NoError> {
        let key = cacheKey(asset)
        
        return SignalProducer { sink, disposable in
            // cache has to be declared locally to solve a compile time compatibility issue between SDWebImage and ReactiveCocoa
            let cache = SDImageCache(namespace: "org.xassets.XAssets.ImageCache")
            cache.clearMemory()
            cache.queryDiskCacheForKey(key) { image, type in
                println(image)
                if image != nil {
                    sendNext(sink, image)
                    sendCompleted(sink)
                }
                else {
                    let image = self.drawImage(asset)
                    
                    cache.storeImage(image, forKey: key)
                    sendNext(sink, image)
                    sendCompleted(sink)
                }
            }
        }
    }
    
    private class func drawImage(asset: Asset) -> UIImage {
        
        switch(asset){
        case let .FemaleIcon(scale):
            return AssetsKit.imageOfFemaleIcon(scale: scale)
        case let .MaleIcon(scale):
            return AssetsKit.imageOfMaleIcon(scale: scale)
        case let .CakeIcon(scale):
            return AssetsKit.imageOfCakeIcon(scale: scale)
        case let .FlameIcon(scale):
            return AssetsKit.imageOfFlameIcon(scale: scale)
        case let .CarIcon(scale):
            return AssetsKit.imageOfCarIcon(scale: scale)
        case let .EtcIcon(scale):
            return AssetsKit.imageOfEtcIcon(scale: scale)
        case let .WTGButtonTapped(scale):
            return AssetsKit.imageOfWTGButtonTapped(scale: scale)
        case let .WTGButtonUntapped(scale):
            return AssetsKit.imageOfWTGButtonUntapped(scale: scale)
        case let .PriceTag(scale, tag):
            return AssetsKit.imageOfPriceTagBackground(scale: scale)
        case let .HomeButtonTapped(scale):
            return AssetsKit.imageOfHomeButtonTapped(scale: scale)
        case let .HomeButtonUntapped(scale):
            return AssetsKit.imageOfHomeButtonUntapped(scale: scale)
        case let .NearbyButtonTapped(scale):
            return AssetsKit.imageOfNearbyButtonTapped(scale: scale)
        case let .NearbyButtonUntapped(scale):
            return AssetsKit.imageOfNearbyButtonUntapped(scale: scale)
        case let .ChatButtonTapped(scale):
            return AssetsKit.imageOfChatButtonTapped(scale: scale)
        case let .ChatButtonUntapped(scale):
            return AssetsKit.imageOfChatButtonUntapped(scale: scale)
        case let .ProfileButtonTapped(scale):
            return AssetsKit.imageOfProfileButtonTapped(scale: scale)
        case let .ProfileButtonUntapped(scale):
            return AssetsKit.imageOfProfileButtonUntapped(scale: scale)
        case let .NavBarSearchButton(scale):
            return AssetsKit.imageOfNavBarSearchButton(scale: scale)
        case let .NavbarFilterButton(scale):
            return AssetsKit.imageOfNavbarFilterButton(scale: scale)
        }
    }
    
    private class func cacheKey(asset: Asset) -> String {
        
        switch(asset){
        case let .FemaleIcon(scale):
            return "FemaleIcon\(scale)"
        case let .MaleIcon(scale):
            return "MaleIcon\(scale)"
        case let .CakeIcon(scale):
            return "CakeIcon\(scale)"
        case let .FlameIcon(scale):
            return "FlameIcon\(scale)"
        case let .CarIcon(scale):
            return "CarIcon\(scale)"
        case let .EtcIcon(scale):
            return "EtcIcon\(scale)"
        case let .WTGButtonTapped(scale):
            return "WTGButtonTapped\(scale)"
        case let .WTGButtonUntapped(scale):
            return "WTGButtonUntapped\(scale)"
        case let .PriceTag(scale, tag):
            return "PriceTag\(scale)\(tag)"
        case let .HomeButtonTapped(scale):
            return "HomeButtonTapped\(scale)"
        case let .HomeButtonUntapped(scale):
            return "HomeButtonUntapped\(scale)"
        case let .NearbyButtonTapped(scale):
            return "NearbyButtonTapped\(scale)"
        case let .NearbyButtonUntapped(scale):
            return "NearbyButtonUntapped\(scale)"
        case let .ChatButtonTapped(scale):
            return "ChatButtonTapped\(scale)"
        case let .ChatButtonUntapped(scale):
            return "ChatButtonUntapped\(scale)"
        case let .ProfileButtonTapped(scale):
            return "ProfileButtonTapped\(scale)"
        case let .ProfileButtonUntapped(scale):
            return "ProfileButtonUntapped\(scale)"
        case let .NavBarSearchButton(scale):
            return "NavBarSearchButton\(scale)"
        case let .NavbarFilterButton(scale):
            return "NavbarFilterButton\(scale)"
        }
    }
}