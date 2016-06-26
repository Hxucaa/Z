//
//  ImageAssets.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-03.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    enum Asset: String {
        case Arrow_Back_64 = "arrow-back-64"
        case Back_Button_Icon = "Back Button Icon"
        case Birthday = "Birthday"
        case Businessplaceholder = "businessplaceholder"
        case CellPlaceHolder = "cellPlaceHolder"
        case DistanceIcon = "distanceIcon"
        case DownArrow = "downArrow"
        case Edit_Button = "Edit Button"
        case Logo = "Logo"
        case Low_Polyy = "Low-Polyy"
        case MapPin = "mapPin"
        case Nickname = "Nickname"
        case PersonIcon = "personIcon"
        case Profile = "profile"
        case ProfileHeaderBackground = "ProfileHeaderBackground"
        case Profilepicture = "profilepicture"
        case Pull_To_Refresh_Arrow = "Pull To Refresh Arrow"
        case RowDividerBackground = "rowDividerBackground"
        case Treat_Filled = "treat-filled"
        case Treat = "treat"
        case Whatsup = "Whatsup"
        case Wtg_Filled = "wtg-filled"
        case Wtg = "wtg"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}