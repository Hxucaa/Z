//
//  BasicUserInfoViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray
import Dollar
import AVOSCloud

public class BasicUserInfoViewModel : IBasicUserInfoViewModel {
    
    // MARK: - Outputs
    private let _profileImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.profilepicture))
    public var profileImage: AnyProperty<UIImage?> {
        return AnyProperty(_profileImage)
    }
    
    private let _nickname: MutableProperty<String>
    public var nickname: AnyProperty<String> {
        return AnyProperty(_nickname)
    }
    
    private let _ageGroup: MutableProperty<String>
    public var ageGroup: AnyProperty<String> {
        return AnyProperty(_ageGroup)
    }
    
    private let _horoscope: MutableProperty<String>
    public var horoscope: AnyProperty<String> {
        return AnyProperty(_horoscope)
    }
    
    private let _status: MutableProperty<String>
    public var status: AnyProperty<String> {
        return AnyProperty(_status)
    }
    
    private let _gender: MutableProperty<String>
    public var gender: AnyProperty<String> {
        return AnyProperty(_gender)
    }
    
    private let _ageGroupBackgroundColor: ConstantProperty<UIColor>
    public var ageGroupBackgroundColor: AnyProperty<UIColor> {
        return AnyProperty(_ageGroupBackgroundColor)
    }
    
    public let user: User
    
    
    // MARK: - Properties
    private let imageService: IImageService
    
    
    // MARK: - Initializers
    public init(imageService: IImageService, user: User, nickname: String?, ageGroup: AgeGroup?, horoscope: Horoscope?, gender: Gender, profileImage: ImageFile?, status: String?) {
        self.imageService = imageService
        
        self.user = user
        
        if let nickname = nickname {
            _nickname = MutableProperty(nickname)
        } else {
            _nickname = MutableProperty("")
        }
        
        _ageGroup = MutableProperty(convertAgeGroup(ageGroup))
        
        _horoscope = MutableProperty(convertHoroscope(horoscope))
        
        if let status = status {
            _status = MutableProperty(status)
        } else {
            _status = MutableProperty("")
        }
        
        _gender = MutableProperty(gender.description)
        
        switch gender {
        case .Female:
            _ageGroupBackgroundColor = ConstantProperty(.x_FemaleAgeGroupBG())
            _ageGroup.put(Icons.Female+" "+_ageGroup.value)
        case .Male:
            _ageGroupBackgroundColor = ConstantProperty(.blueColor())
            _ageGroup.put(Icons.Male+" "+_ageGroup.value)
        }
        
        if let url = profileImage?.url, nsurl = NSURL(string: url) {
            self.imageService.getImage(nsurl)
                .start(next: {
                    self._profileImage.put($0)
                })
        }
    }
}
