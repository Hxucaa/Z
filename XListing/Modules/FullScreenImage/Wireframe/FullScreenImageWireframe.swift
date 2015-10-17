//
//  FullScreenImageWireframe.swift
//  XListing
//
//  Created by Bruce Li on 2015-10-14.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public final class FullScreenImageWireframe : IFullScreenImageWireframe {
    
    private let imageService: IImageService
    
    public required init(imageService: IImageService) {
        self.imageService = imageService
    }
    
    private func injectViewModelToViewController() -> FullScreenImageViewController {
        let viewController = FullScreenImageViewController()
        let viewmodel = FullScreenImageViewModel(imageService: imageService)
        
        return viewController
    }
    
    
    public func viewController() -> FullScreenImageViewController {
        return injectViewModelToViewController()
    }
}