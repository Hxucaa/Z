//
//  ProfileHeaderViewModel.swift
//  XListing
//
//  Created by Anson on 2015-07-26.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Dollar

public final class ProfileHeaderViewModel : BasicUserInfoViewModel {
    
    // MARK: - Input
    
    // MARK: - Output
    
    // MARK: - Services
//    private let imageService: IImageService
//    
    public override init(imageService: IImageService, user: User, nickname: String?, ageGroup: AgeGroup?, horoscope: Horoscope?, gender: Gender, profileImage: ImageFile?, status: String?) {
        println("haha")
        
        super.init(imageService: imageService, user: user, nickname: nickname, ageGroup: ageGroup, horoscope: horoscope, gender: gender, profileImage: profileImage, status: status)
        
    }
    
    // MARK: Setup
}