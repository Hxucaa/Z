//
//  WantToGoViewModel.swift
//  XListing
//
//  Created by William Qi on 2015-06-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public final class WantToGoViewModel : ReactiveTableCellViewModel {
    
    // MARK: Properties
    public let profilePictureNSURL: ConstantProperty<NSURL?>
    public let displayName: ConstantProperty<String>
    public let horoscope: ConstantProperty<String>
    public let ageGroup: ConstantProperty<String>
    public let gender: ConstantProperty<String>
    
    // MARK: Services
    private let participationService: IParticipationService
    
    // MARK: Setup
    public init(participationService: IParticipationService, profilePicture: AVFile?, displayName: String?, horoscope: String?, ageGroup: String?, gender: String?) {
        self.participationService = participationService
        
        if let displayName = displayName {
            self.displayName = ConstantProperty(displayName)
        } else {
            self.displayName = ConstantProperty("")
        }
        if let horoscope = horoscope {
            self.horoscope = ConstantProperty(horoscope)
        } else {
            self.horoscope = ConstantProperty("")
        }
        if let ageGroup = ageGroup {
            self.ageGroup = ConstantProperty(ageGroup + " 后")
        } else {
            self.ageGroup = ConstantProperty("")
        }
        if let gender = gender {
            self.gender = ConstantProperty(gender)
        } else {
            self.gender = ConstantProperty("")
        }
        
        if let url = profilePicture?.url {
            profilePictureNSURL = ConstantProperty<NSURL?>(NSURL(string: url))
        }
        else {
            // should never get here
            profilePictureNSURL = ConstantProperty<NSURL?>(NSURL(string: ""))
        }
    }
}