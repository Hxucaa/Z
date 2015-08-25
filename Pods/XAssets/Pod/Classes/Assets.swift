//
//  Asset.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public enum Asset {
    case FemaleIcon(scale: CGFloat)
    case MaleIcon(scale: CGFloat)
    case CakeIcon(scale: CGFloat)
    case FlameIcon(scale: CGFloat)
    case CarIcon(scale: CGFloat)
    case EtcIcon(scale: CGFloat)
    case WTGButtonTapped(scale: CGFloat)
    case WTGButtonUntapped(scale: CGFloat)
    case PriceTag(scale: CGFloat, tag: String)
    case HomeButtonTapped(scale: CGFloat)
    case HomeButtonUntapped(scale: CGFloat)
    case NearbyButtonTapped(scale: CGFloat)
    case NearbyButtonUntapped(scale: CGFloat)
    case ChatButtonTapped(scale: CGFloat)
    case ChatButtonUntapped(scale: CGFloat)
    case ProfileButtonTapped(scale: CGFloat)
    case ProfileButtonUntapped(scale: CGFloat)
    case NavBarSearchButton(scale: CGFloat)
    case NavbarFilterButton(scale: CGFloat)
}