//
//  BasicUserInfoViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import ReactiveArray
import AVOSCloud

public class BasicUserInfoViewModel : IBasicUserInfoViewModel {
    
    // MARK: - Outputs
    private let _coverPhoto: MutableProperty<UIImage?> = MutableProperty(ImageAsset.profilePlaceholder)
    public var coverPhoto: AnyProperty<UIImage?> {
        return AnyProperty(_coverPhoto)
    }
    public let coverPhotoUrl: SignalProducer<NSURL?, NoError>
    public let nickname: SignalProducer<String, NoError>
    public let ageGroup: SignalProducer<String, NoError>
    public let horoscope: SignalProducer<String, NoError>
    public let whatsUp: SignalProducer<String?, NoError>
    public let gender: SignalProducer<String, NoError>
    public let ageGroupBackgroundColor: SignalProducer<UIColor, NoError>
    
    
    // MARK: - Properties
    private let user: User
    private let imageService: IImageService
    
    
    // MARK: - Initializers
    public init(imageService: IImageService, user: User) {
        self.imageService = imageService
        
        self.user = user
        
        coverPhotoUrl = SignalProducer(value: user.coverPhoto?.url)
        
        switch user.gender {
        case .Female:
            ageGroupBackgroundColor = SignalProducer(value: .x_FemaleAgeGroupBG())
            ageGroup = SignalProducer(value: Icons.Female.rawValue + " " + user.ageGroup.description)
        case .Male:
            ageGroupBackgroundColor = SignalProducer(value: .x_MaleAgeGroupBG())
            ageGroup = SignalProducer(value: Icons.Male.rawValue + " " + user.ageGroup.description)
        }
        
        nickname = SignalProducer(value: user.nickname)
        horoscope = SignalProducer(value: user.horoscope.description)
        whatsUp = SignalProducer(value: user.whatsUp)
        gender = SignalProducer(value: user.gender.description)
        
        
        if let url = user.coverPhoto?.url {
            self.imageService.getImageBy(url)
                .startWithNext {
                    self._coverPhoto.value = $0
                }
        }
    }
}
