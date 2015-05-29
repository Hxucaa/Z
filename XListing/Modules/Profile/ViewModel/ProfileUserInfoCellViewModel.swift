//
//  ProfileUserInfoCellViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-28.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class ProfileUserInfoCellViewModel {
    
    public let nickname: ConstantProperty<String>
//    public let horoscope: ConstantProperty<String>
//    public let ageGtoup: ConstantProperty<String>
    
    public init(currentUser: User) {
        nickname = ConstantProperty(currentUser.nickname)
    }
    
    
}