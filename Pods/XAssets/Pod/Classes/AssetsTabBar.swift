//
//  AssetsTabBar.swift
//  Pods
//
//  Created by Lance Zhu on 2015-09-17.
//
//

import Foundation

public final class AssetsTabBar {
    public class func imageOfHomeIcon(isSelected: Bool) -> UIImage {
        return AssetsKit.imageOfHomeButton(scaleX: 1, scaleY: 1, ifPressed: isSelected)
    }
    
    public class func imageOfNearbyIcon(isSelected: Bool) -> UIImage {
        return AssetsKit.imageOfNearbyButton(scaleX: 1, scaleY: 1, ifPressed: isSelected)
    }
    
    public class func imageOfProfileIcon(isSelected: Bool) -> UIImage {
        return AssetsKit.imageOfProfileButton(scaleX: 1, scaleY: 1, ifPressed: isSelected)
    }
}