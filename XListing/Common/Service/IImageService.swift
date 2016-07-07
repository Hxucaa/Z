//
//  IImageService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-14.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift

public protocol IImageService : class {
    
    /**
    Fetch the original size of the image based on an `NSURL`.
    
    - parameter url: The `NSURL` of the image.
    
    - returns: A signal producer that contains the `UIImage`.
    */
    func getImage(url: NSURL) -> Observable<UIImage>
    
    /**
    Fetch the original size of the `ImageFile`
    
    - parameter image: The `ImageFile`
    
    - returns: A signal producer that contains the `UIImage`.
    */
    func getImage(image: ImageFile) -> Observable<UIImage>
    
    /**
    Fetch a thumbnail of the `ImageFile`.
    
    - parameter image:         an `ImageFile`
    - parameter thumbnailSize: The dimension of the thumbnail.
    
    - returns: A signal producer that contains the thumbnail.
    */
    func getThumbnail(image: ImageFile, thumbnailSize: Thumbnail.Dimension) -> Observable<Thumbnail>
}