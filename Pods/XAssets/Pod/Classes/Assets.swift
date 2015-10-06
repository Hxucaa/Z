//
//  Asset.swift
//  Pods
//
//  Created by Lance Zhu on 2015-08-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public enum Asset {
    case VenusLabel(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, textInput: String?)
    case MarsLabel(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, textInput: String?)
    case ShareButton(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case FemaleIcon(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case MaleIcon(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case CakeIcon(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case FlameIcon(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case CarIcon(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case EtcIcon(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case PriceIcon(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case HomeButton(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case NearbyButton(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case ChatButton(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case ProfileButton(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case SearchButton(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case FilterButton(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case TreatIcon(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case WTGIcon(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, pressed: Bool?, shadow: Bool?)
    case JoinButton(size: CGSize?, backgroundColor: UIColor?, opaque: Bool?, imageContextScale: CGFloat?, ifAA: Bool?, ifGo: Bool?, ifPay: Bool?, ifUnTapped: Bool?)
    
    /// Retrieve the drawing in `UIImage` for the `Asset`.
    internal func image() -> UIImage {
        
        switch(self){
        case let .VenusLabel(size, backgroundColor, opaque, imageContextScale, textInput):
            return AssetsKit.x_imageOfVenusLabel(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, textInput: textInput)
        case let .MarsLabel(size, backgroundColor, opaque, imageContextScale, textInput):
            return AssetsKit.x_imageOfMarsLabel(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, textInput: textInput)
        case let .ShareButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfShareButton(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .FilterButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfFilterButton(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .SearchButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfSearchButton(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .ProfileButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfProfileButton(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .ChatButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfChatButton(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .NearbyButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfNearbyButton(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .HomeButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfHomeButton(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .PriceIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfPriceIcon(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .CakeIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfCakeIcon(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .FemaleIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfFemaleIcon(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .MaleIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfMaleIcon(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .FlameIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfFlameIcon(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .CarIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfCarIcon(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .EtcIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfEtcIcon(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .TreatIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfTreatIcon(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .WTGIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return AssetsKit.x_imageOfWTGIcon(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, pressed: pressed, shadow: shadow)
        case let .JoinButton(size, backgroundColor, opaque, imageContextScale, ifAA, ifGo, ifPay, ifNotTapped):
            return AssetsKit.x_imageOfJoinButton(size, drawingSize: drawingSize(), backgroundColor: backgroundColor, opaque: opaque, imageContextScale: imageContextScale, ifAA: ifAA, ifGo: ifGo, ifPay: ifPay, ifNotTapped: ifNotTapped)
        }
    }
    
    /// Retrieve the cache key for the `Asset`.
    internal func cacheKey() -> String {
        
        switch(self){
        case let .VenusLabel(size, backgroundColor, opaque, imageContextScale, textInput):
            return "VenusLabel|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(textInput)"
        case let .MarsLabel(size, backgroundColor, opaque, imageContextScale, textInput):
            return "MarsLabel|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(textInput)"
        case let .ShareButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "ShareButton|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .FilterButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "FilterButton|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .SearchButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "SearchButton|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .ProfileButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "ProfileButton|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .ChatButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "ChatButton|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .NearbyButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "NearbyButton|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .HomeButton(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "HomeButton|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .PriceIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "PriceIcon|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .CakeIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "CakeIcon|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .FemaleIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "FemaleIcon|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .MaleIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "MaleIcon|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .FlameIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "FlameIcon|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .CarIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "CarIcon|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .EtcIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "EtcIcon|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .TreatIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "TreatIcon|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .WTGIcon(size, backgroundColor, opaque, imageContextScale, pressed, shadow):
            return "WTGIcon|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(pressed)|\(shadow)"
        case let .JoinButton(size, backgroundColor, opaque, imageContextScale, ifAA, ifGo, ifPay, ifNotTapped):
            return "JoinButton|\(size)|\(backgroundColor)|\(opaque)|\(imageContextScale)|\(ifAA)|\(ifGo)|\(ifPay)|\(ifNotTapped)"
        }
    }
    
    internal func drawingSize() -> CGSize {
        switch(self) {
        case .VenusLabel:
            return CGSizeMake(58, 17)
        case .MarsLabel:
            return CGSizeMake(58, 17)
        case .ShareButton:
            return CGSizeMake(26, 25)
        case .FilterButton:
            return CGSizeMake(26, 25)
        case .SearchButton:
            return CGSizeMake(20, 21)
        case .ProfileButton:
            return CGSizeMake(22, 27)
        case .ChatButton:
            return CGSizeMake(27, 27)
        case .NearbyButton:
            return CGSizeMake(27, 27)
        case .HomeButton:
            return CGSizeMake(32, 27)
        case .PriceIcon:
            return CGSizeMake(11, 11)
        case .CakeIcon:
            return CGSizeMake(45, 36)
        case .FemaleIcon:
            return CGSizeMake(36, 40)
        case .MaleIcon:
            return CGSizeMake(37, 40)
        case .FlameIcon:
            return CGSizeMake(32, 34)
        case .CarIcon:
            return CGSizeMake(14, 13)
        case .EtcIcon:
            return CGSizeMake(32,11)
        case .JoinButton:
            return CGSizeMake(69, 32)
        case .TreatIcon:
            return CGSizeMake(19, 20)
        case .WTGIcon:
            return CGSizeMake(18, 17)
        default:
            return CGSizeMake(0, 0)
        }
    }
}