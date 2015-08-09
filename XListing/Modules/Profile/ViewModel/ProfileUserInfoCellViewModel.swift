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
    
    // MARK: - Outputs
    public let nickname: ConstantProperty<String?>
    
    // MARK: - Initializers
    public init(currentUser: User) {
        nickname = ConstantProperty(currentUser.nickname)
    }
    
    
}