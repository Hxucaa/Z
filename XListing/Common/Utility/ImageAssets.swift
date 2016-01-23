//
//  ImageAssets.swift
//  XListing
//
//  Created by William Qi on 2015-07-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public struct ImageAssets {
    static let appIcon = "appIcon"
    static let downArrow = "downArrow"
    static let lowPoly = "Low-Polyy"
    static let mapPin = "mapPin"
    static let profile = "profile"
    static let profilepicture = "profilepicture"
    static let divider = "rowDividerBackground"
    static let businessplaceholder = "businessplaceholder"
    static let logo = "Logo"
    static let pullToRefreshArrow = "Pull To Refresh Arrow"
    static let profileHeaderBackground = "ProfileHeaderBackground"
    static let editIcon = "Edit Button"
    static let backButtonIcon = "Back Button Icon"
}

public final class ImageAsset {
    public static let placeholder = UIImage(named: ImageAssets.businessplaceholder)!
    public static let profilePlaceholder = UIImage(named: "businessplaceholder")!
}