//
//  AssetManager.swift
//  XListing
//
//  Created by Anson on 2015-08-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SDWebImage
import XAssets

public class AssetManager {

    public class func getImage(#name: ImageName, scale: CGFloat, tag: String, oncomplete closure: UIImage -> Void){
        let cache = SDImageCache(namespace: "XListingImageCache")
        let key = name.rawValue + "\(scale)" + tag
        cache.queryDiskCacheForKey(key){ (image, type) in
            if image != nil{
                closure(image)
            }
            else{
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)){
                    var image = self.drawImage(name: name, scale: scale, tag: tag)
                    SDImageCache.sharedImageCache().storeImage(image, forKey: key)
                    dispatch_async(dispatch_get_main_queue()){
                        closure(image)
                    }
                }
            }
        }
    }
    
    public class func drawImage(#name: ImageName, scale: CGFloat, tag: String) -> UIImage{
        var image = UIImage()
        switch(name){
            case ImageName.FemaleIcon: image = AssetsKit.imageOfFemaleIcon(scale: scale)
            case ImageName.MaleIcon: image = AssetsKit.imageOfMaleIcon(scale: scale)
            case ImageName.CakeIcon: image = AssetsKit.imageOfCakeIcon(scale: scale)
            case ImageName.FlameIcon: image =  AssetsKit.imageOfFlameIcon(scale: scale)
            case ImageName.CarIcon: image =  AssetsKit.imageOfCarIcon(scale: scale)
            case ImageName.EtcIcon: image =  AssetsKit.imageOfEtcIcon(scale: scale)
            case ImageName.WTGButtonTapped: image =  AssetsKit.imageOfWTGButtonTapped(scale: scale)
            case ImageName.WTGButtonUntapped: image =  AssetsKit.imageOfWTGButtonUntapped(scale: scale)
            case ImageName.PriceTag: image =  AssetsKit.imageOfPriceTagBackground(scale: scale)
            case ImageName.HomeButtonTapped: image =  AssetsKit.imageOfHomeButtonTapped(scale: scale)
            case ImageName.HomeButtonUntapped: image =  AssetsKit.imageOfHomeButtonUntapped(scale: scale)
            case ImageName.NearbyButtonTapped: image =  AssetsKit.imageOfNearbyButtonTapped(scale: scale)
            case ImageName.NearbyButtonUntapped: image =  AssetsKit.imageOfNearbyButtonUntapped(scale: scale)
            case ImageName.ChatButtonTapped: image =  AssetsKit.imageOfChatButtonTapped(scale: scale)
            case ImageName.ChatButtonUntapped: image =  AssetsKit.imageOfChatButtonUntapped(scale: scale)
            case ImageName.ProfileButtonTapped: image =  AssetsKit.imageOfProfileButtonTapped(scale: scale)
            case ImageName.ProfileButtonUntapped: image =  AssetsKit.imageOfProfileButtonUntapped(scale: scale)
            case ImageName.NavBarSearchButton: image =  AssetsKit.imageOfNavBarSearchButton(scale: scale)
            case ImageName.NavbarFilterButton: image =  AssetsKit.imageOfNavbarFilterButton(scale: scale)
        }
        return image
    }

}