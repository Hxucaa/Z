//
//  ParticipantsViewModel.swift
//  XListing
//
//  Created by Anson on 2015-08-22.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class ParticipantViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    public let avatar: MutableProperty<UIImage?> = MutableProperty(nil)
    
    // MARK: - Properties
    private let imageService: IImageService
    private let user: User
    
    // MARK: - Initializers
    public init(imageService: IImageService, user: User){
        self.imageService = imageService
        self.user = user
        
        if let image = user.profileImg_, url = image.url, nsurl = NSURL(string: url) {
            self.imageService.getImage(nsurl)
                .start (next :{ [weak self] in
                    self?.avatar.put($0)
                })
        }
    }
}
