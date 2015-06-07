//
//  SignUpViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public typealias AgeLimit = (floor: NSDate, ceil: NSDate)

public final class SignUpViewModel : NSObject {
    
    private let userService: IUserService
    
    public var nickname: String?
    public var birthday: NSDate?
    public var profileImage: UIImage?
    
    public var ageLimit: AgeLimit {
        get {
            func calDate(currentDate: NSDate, age: Int) -> NSDate {
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: currentDate)
                let currentYear = components.year
                let currentMonth = components.month
                let currentDay = components.day
                
                let ageComponents = NSDateComponents()
                ageComponents.year = currentYear - MIN_AGE
                ageComponents.month = currentMonth
                ageComponents.day = currentDay
                return calendar.dateFromComponents(ageComponents)!
            }
            
            // Restrict birthdays
            let currentDate = NSDate()
            
            return (floor: calDate(currentDate, MAX_AGE), ceil: calDate(currentDate, MIN_AGE))
        }
    }
    
    private var birthdaySignal: Stream<NSDate?>!
    private var nicknameSignal: Stream<String?>!
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
    
    public func updateProfile() -> Stream<Bool> {
        if let currentUser = userService.currentUser() {
            currentUser.birthday = birthday
            currentUser.nickname = nickname
            let imageData = UIImagePNGRepresentation(profileImage)
            return Stream<Bool>.fromTask(userService.save(currentUser))
        }
        else {
            AccountLogError("Function called while user is not logged in")
            return Stream<Bool>.error(NSError(domain: "SignUpViewModel", code: 899, userInfo: nil))
        }
    }
    
    private func setupNickname() {
        nicknameSignal = KVO.stream(self, "nickname")
            |> map { $0 as? String }
            // TODO: add regex to allow only a subset of characters
            |> filter { count($0!) > 0 }
        
        isNicknameValidSignal = nicknameSignal
            // starting value as false
            |> map { _ in return true }
            |> startWith(false)
    }
    
    private func setupBirthday() {
        birthdaySignal = KVO.stream(self, "birthday")
            |> map { $0 as? NSDate }
        
        isBirthdayValidSignal = birthdaySignal
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
            |> peek { AccountLogDebug($0.values.description) }
            |> map { (values, changedValues) -> NSNumber? in
                return values.reduce(Optional<Bool>.Some(true)) { v1, v2 in
                    if let v1 = v1, v2 = v2 {
                        return v1 && v2
                    }
                    return false
                }
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