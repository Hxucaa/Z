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
    
    // MARK: Services
    private let participationService: IParticipationService
    
    // MARK: Setup
    public init(participationService: IParticipationService, profilePicture: AVFile?, displayName: String?, horoscope: String?, ageGroup: String?) {
        self.participationService = participationService

        self.displayName = ConstantProperty(displayName!)
        self.horoscope = ConstantProperty(horoscope!)
        self.ageGroup = ConstantProperty(ageGroup!)
        
        if let url = profilePicture?.url {
            profilePictureNSURL = ConstantProperty<NSURL?>(NSURL(string: url))
        }
        else {
            // TODO: temporary fallback
             profilePictureNSURL = ConstantProperty<NSURL?>(NSURL(string: "http://www.phoenixpalace.co.uk/images/background/aboutus.jpg"))
        }
    }
}