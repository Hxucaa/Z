//
//  ProfilePhotoCellViewModel.swift
//  XListing
//
//  Created by Bruce Li on 2015-10-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa


public final class ProfilePhotoCellViewModel {
    
    private let _image: MutableProperty<UIImage?> = MutableProperty(UIImage(named: "profilepicture"))
    public var image: AnyProperty<UIImage?> {
        return AnyProperty(_image)
    }
    
    private let imageService: IImageService
    
    public init (imageService: IImageService, image: ImageFile?) {
        self.imageService = imageService
        
        if let url = image?.url, nsurl = NSURL(string: url) {
            self.imageService.getImageBy(nsurl)
                .startWithNext { image in
                    self._image.value = image
                }
        }
    }
}