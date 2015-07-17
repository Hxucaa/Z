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
    public let profilePicture: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.profilepicture))
    public let displayName: ConstantProperty<String>
    public let horoscope: ConstantProperty<String>
    public let ageGroup: ConstantProperty<String>
    public let gender: ConstantProperty<String>
    
    // MARK: Services
    private let participationService: IParticipationService
    private let imageService: IImageService
    
    // MARK: Setup
    public init(participationService: IParticipationService, imageService: IImageService, profilePicture: AVFile?, displayName: String?, horoscope: String?, ageGroup: String?, gender: String?) {
        self.participationService = participationService
        self.imageService = imageService
        
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

        if let stringURL = profilePicture?.url {
            if let url = NSURL(string: stringURL) {
                imageService.getImage(url)
                    |> start(next: {
                        self.profilePicture.put($0)
                    })
            }
        }
        
    }
}










