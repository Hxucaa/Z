//
//  IProfileEditWireframe.swift
//  XListing
//
//  Created by Bruce Li on 2015-08-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IProfileEditWireframe : class {
    
    // MARK: - Initializers
    
    init(meService: IMeService, imageService: IImageService)
    
    func viewController() -> ProfileEditViewController
}
