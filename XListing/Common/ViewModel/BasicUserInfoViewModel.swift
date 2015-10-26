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
    public var profileImage: PropertyOf<UIImage?> {
        return PropertyOf(_profileImage)
    }
    
    private let _nickname: MutableProperty<String>
    public var nickname: PropertyOf<String> {
        return PropertyOf(_nickname)
    }
    
    private let _ageGroup: MutableProperty<String>
    public var ageGroup: PropertyOf<String> {
        return PropertyOf(_ageGroup)
    }
    
    private let _horoscope: MutableProperty<String>
    public var horoscope: PropertyOf<String> {
        return PropertyOf(_horoscope)
    }
    
    private let _status: MutableProperty<String>
    public var status: PropertyOf<String> {
        return PropertyOf(_status)
    }
    
    private let _gender: MutableProperty<String>
    public var gender: PropertyOf<String> {
        return PropertyOf(_gender)
    }
    
    private let _ageGroupBackgroundColor: ConstantProperty<UIColor>
    public var ageGroupBackgroundColor: PropertyOf<UIColor> {
        return PropertyOf(_ageGroupBackgroundColor)
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
                |> start(next: {
                    self._profileImage.put($0)
                })
        }
    }
}
