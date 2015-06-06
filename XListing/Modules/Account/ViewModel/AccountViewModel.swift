//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public typealias AgeLimit = (floor: NSDate, ceil: NSDate)

public final class AccountViewModel : NSObject, IAccountViewModel {
    
    private let userService: IUserService
    public var nickname: NSString?
    public var birthday: NSDate?
    public var profileImage: UIImage?
    
    public var ageLimit: AgeLimit {
        get {
            // Restrict birthdays
            let currentDate = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: currentDate)
            let currentYear = components.year
            let currentMonth = components.month
            let currentDay = components.day
            
            let maximumAgeComponents = NSDateComponents()
            maximumAgeComponents.year = currentYear - MIN_AGE
            maximumAgeComponents.month = currentMonth
            maximumAgeComponents.day = currentDay
            let maximumDate = calendar.dateFromComponents(maximumAgeComponents)
            
            let minimumAgeComponents = NSDateComponents()
            minimumAgeComponents.year = currentYear - MAX_AGE
            minimumAgeComponents.month = currentMonth
            minimumAgeComponents.day = currentDay
            let minimumDate = calendar.dateFromComponents(minimumAgeComponents)
            
            return (floor: minimumDate!, ceil: maximumDate!)
        }
    }
    
    private var birthdaySignal: Stream<NSDate?>!
    private var nicknameSignal: Stream<NSString?>!
    private var profileImageSignal: Stream<UIImage?>!
    
    /// Nickname validity signal
    public var isNicknameValidSignal: Stream<Bool>!
    /// Birthday validity signal
    public var isBirthdayValidSignal: Stream<Bool>!
    /// Profile image validity signal
    public var isProfileImageValidSignal: Stream<Bool>!
    /// All inputs validity signal
    public var areInputsValidSignal: Stream<NSNumber?>!
    
    public required init(userService: IUserService) {
        self.userService = userService
        
        super.init()
        
        setupNickname()
        setupBirthday()
        setupProfileImage()
        setupAllInputsValid()
        
    }
    
    public func updateProfile(nickname: String, birthday: NSDate, profileImage: UIImage?) -> Task<Int, Bool, NSError> {
        let currentUser = userService.currentUser()!
        currentUser.birthday = birthday
        currentUser.nickname = nickname
        let imageData = UIImagePNGRepresentation(profileImage)
        return userService.save(currentUser)
    }
    
    private func setupNickname() {
        nicknameSignal = KVO.stream(self, "nickname")
            |> map { $0 as? NSString }
            // TODO: add regex to allow only a subset of characters
            |> filter { $0!.length > 0 }
        
        isNicknameValidSignal = nicknameSignal
            |> peek { println($0) }
            // starting value as false
            |> map { $0!.length > 0 }
            |> startWith(false)
    }
    
    private func setupBirthday() {
        birthdaySignal = KVO.stream(self, "birthday")
            |> map { $0 as? NSDate }
        
        isBirthdayValidSignal = birthdaySignal
            |> peek { println($0) }
            |> map { [unowned self] age -> Bool in
                return self.isValidAge(age!)
            }
            |> startWith(false)
    }
    
    private func setupProfileImage() {
        profileImageSignal = KVO.stream(self, "profileImage")
            |> map { $0 as? UIImage }
            // TODO: manipulate image
            |> map { $0 }
        
        isProfileImageValidSignal = profileImageSignal
            |> peek { println($0) }
            |> map { _ in return true }
            |> startWith(false)
    }
    
    private func setupAllInputsValid() {
        areInputsValidSignal = [
            isNicknameValidSignal,
            isBirthdayValidSignal,
            isProfileImageValidSignal
        ]
            |> merge2All
            |> peek { AccountLogVerbose($0.values.description) }
            |> map { (values, changedValues) -> NSNumber? in
                if let v0 = values[0], v1 = values[1], v2 = values[2] {
                    return v0 && v1 && v2
                }
                return false
        }
    }
    
    private func isValidAge(age: NSDate) -> Bool {
        let ageLimit = self.ageLimit
        
        // elder than minimum age
        let r1 = age.compare(ageLimit.ceil) == .OrderedAscending
        
        // younger than maximum age
        let r2 = age.compare(ageLimit.floor) == .OrderedDescending
        
        return r1 && r2
    }
}