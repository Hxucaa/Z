//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation

protocol IProfileViewModel : class {
    
    // MARK: - Outputs
    var nickname: String? { get }
    var horoscope: Horoscope? { get }
    var ageGroup: AgeGroup? { get }
    var gender: Gender? { get }
    var whatsUp: String? { get }
    var coverPhotoURL: NSURL? { get }
    
    // MARK: - Properties
    
    
    
}
