//
//  Thumbnail.swift
//  XListing
//
//  Created by Lance Zhu 2015-10-15.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit

public final class Thumbnail : UIImage {
    
    
    public enum Dimension {
        case Small
        case Medium
        
        public var value: (scaleToFit: Bool, width: Int32, height: Int32, quality: Int32, format: String) {
            switch self {
            case .Small: return (true, 400, 300, 70, "jpg")
            case .Medium: return (true, 800, 600, 80, "jpg")
            }
        }
    }
}