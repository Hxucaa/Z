//
//  IFullScreenImageWireframe.swift
//  XListing
//
//  Created by Bruce Li on 2015-10-14.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IFullScreenImageWireframe : class {
    
    // MARK: - Initializers
    
    init(imageService: IImageService)
    
    func viewController() -> FullScreenImageViewController
}
