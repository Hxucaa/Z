//
//  ILogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import ReactKit
import SwiftTask

public protocol IAccountViewModel {
    var birthday: NSDate? { get set }
    var nickname: NSString? { get set }
    var profileImage: UIImage? { get set }
    var ageLimit: AgeLimit { get }
    var isNicknameValidSignal: Stream<Bool>! { get }
    var isBirthdayValidSignal: Stream<Bool>! { get }
    var isProfileImageValidSignal: Stream<Bool>! { get }
    var areInputsValidSignal: Stream<NSNumber?>! { get }
    init(userService: IUserService)
    func updateProfile(nickname: String, birthday: NSDate, profileImage: UIImage?) -> Task<Int, Bool, NSError>
}