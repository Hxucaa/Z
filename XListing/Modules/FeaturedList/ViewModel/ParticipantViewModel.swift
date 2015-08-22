//
//  ParticipantsViewModel.swift
//  XListing
//
//  Created by Anson on 2015-08-22.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public class ParticipantViewModel{
    
    //MARK: Property
    
    public let avatar: MutableProperty<UIImage?> = MutableProperty(UIImage())
    public let user: User
    
    
    
    //MARK: init
    public init(user: User){
        self.user = user
        if let image = user.profileImg, url = image.url, nsurl = NSURL(string: url){
            let imageService = ImageService()
            imageService.getImage(nsurl)
                |> start (next :{ [weak self] in
                    self?.avatar.put($0)
                })
        }
    }
    
    
    //MARK: clean memory
    public func cleanup(){
        avatar.put(nil)
    }
}
