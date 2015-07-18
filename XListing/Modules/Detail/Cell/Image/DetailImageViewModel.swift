//
//  DetailImageViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public struct DetailImageViewModel {
    
    // MARK: Properties
    public let coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    
    // MARK: Services
    private let imageService: IImageService
    
    // MARK: Setup
    public init(imageService: IImageService, coverImageURL: String?) {
        self.imageService = imageService
        
        imageService.getImage(NSURL(string: "http://lasttear.com/wp-content/uploads/2015/03/interior-design-ideas-furniture-architecture-mesmerizing-chinese-restaurant-interior-with-red-nuance-inspiring.jpg")!)
            |> start(next: {
                self.coverImage.put($0)
            })
        
//        if let stringURL = coverImageURL, url = NSURL(string: stringURL) {
//            imageService.getImage(url)
//                |> start(next: {
//                    self.coverImage.put($0)
//                })
//        }
    }
}