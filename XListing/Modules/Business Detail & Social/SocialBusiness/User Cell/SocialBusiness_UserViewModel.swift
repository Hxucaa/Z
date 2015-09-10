//
//  SocialBusiness_UserViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray
import Dollar

// TODO: make this class conform to `ISocialBusiness_UserViewModel`
public final class SocialBusiness_UserViewModel {
    
    // MARK: - Outputs
    public var profileImage: PropertyOf<UIImage?> {
        return PropertyOf(profileImage)
    }
    var nickname: PropertyOf<String> {
        return PropertyOf(nickname)
    }
    var ageGroup: PropertyOf<String> {
        return PropertyOf(ageGroup)
    }
    var horoscope: PropertyOf<String> {
        return PropertyOf(horoscope)
    }
    var status: PropertyOf<String> {
        return PropertyOf(status)
    }
    var participationType: PropertyOf<String> {
        return PropertyOf(participationType)
    }
    var gender: PropertyOf<String> {
        return PropertyOf(gender)
    }
    
    // MARK: - Properties
    private let imageService: IImageService
    private let participationService: IParticipationService
    private let user: User?
    
    // MARK: - Initializers
    public init(participationService: IParticipationService, imageService: IImageService, user: User?) {
        self.participationService = participationService
        self.imageService = imageService
        self.user = user
        
        // set the image with imageService
//        if let url = cover?.url, nsurl = NSURL(string: url) {
//            self.imageService.getImage(nsurl)
//                |> start(next: {
//                    self.coverImage.put($0)
//                })
//        }
        


    }
}
