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
import AVOSCloud

public typealias AgeLimit = (floor: NSDate, ceil: NSDate)

public final class SignUpViewModel : NSObject {
    
    // MARK: - Services
    private let userService: IUserService
    
    // MARK: - Input Receivers
    public var nickname: String?
    public var birthday: NSDate?
    public var profileImage: UIImage?
    
    // MARK: - Input Observer Signals
    private var birthdaySignal: Stream<NSDate?>!
    private var nicknameSignal: Stream<String?>!
    private var profileImageSignal: Stream<UIImage?>!
    
    // MARK: - Latest Valid Input Signals
    private var transformedNicknameProducer: (Void -> Stream<String?>)!
    private var transformedBirthdayProducer: (Void -> Stream<NSDate?>)!
    private var transformedProfileImageProducer: (Void -> Stream<UIImage?>)!
    private var AllInputsValidProduer: (Void -> Stream<Bool?>)!
    
    // MARK: - Output Signals
    /// Nickname validity signal
    public var isNicknameValidSignal: Stream<Bool>!
    /// Birthday validity signal
    public var isBirthdayValidSignal: Stream<Bool>!
    /// Profile image validity signal
    public var isProfileImageValidSignal: Stream<Bool>!
    /// All inputs validity signal
    public var allInputsValidSignal: Stream<Bool?>!
    
    // MARK: - Initializers
    
    public required init(userService: IUserService) {
        self.userService = userService
        
        super.init()
        
        setupNickname()
        setupBirthday()
        setupProfileImage()
        setupAllInputsValid()
        
    }
    
    // MARK: - Setup Functions
    
    private func setupNickname() {
        // KVO instance variable nickname
        nicknameSignal = KVO.stream(self, "nickname")
            |> map { $0 as? String }
            // TODO: add regex to allow only a subset of characters
            |> filter { count($0!) > 0 }
        
        // save the latest result
        transformedNicknameProducer = self.nicknameSignal |>> replay(capacity: 1)
        
        isNicknameValidSignal = nicknameSignal
            |> map { _ in return true }
    }
    
    private func setupBirthday() {
        // KVO instance variable birthday
        birthdaySignal = KVO.stream(self, "birthday")
            |> map { $0 as? NSDate }
        
        // save the latest result
        transformedBirthdayProducer = self.birthdaySignal |>> replay(capacity: 1)
        
        isBirthdayValidSignal = birthdaySignal
            |> map { [unowned self] age -> Bool in
                return self.isValidAge(age!)
            }
    }
    
    private func setupProfileImage() {
        // KVO instance variable profileImage
        profileImageSignal = KVO.stream(self, "profileImage")
            |> map { $0 as? UIImage }
        
        // save the latest result
        transformedProfileImageProducer = self.profileImageSignal |>> replay(capacity: 1)
        
        isProfileImageValidSignal = profileImageSignal
            |> map { _ in return true }
    }
    
    private func setupAllInputsValid() {
        allInputsValidSignal = [
            isNicknameValidSignal,
            isBirthdayValidSignal,
            isProfileImageValidSignal
        ]
            // Combine latest events from the signals
            |> merge2All
            |> peek { AccountLogDebug($0.values.description) }
            // Map them to a single boolean value
            |> map { (values, changedValues) -> Bool? in
                return values.reduce(Optional<Bool>.Some(true)) { v1, v2 in
                    if let v1 = v1, v2 = v2 {
                        return v1 && v2
                    }
                    return false
                }
            }
            |> startWith(false)
        
        // save the latest result
        AllInputsValidProduer = self.allInputsValidSignal |>> replay(capacity: 1)
    }

    // MARK: - Public Functions
    
    /**
    Update user's profile. Data should already be present on the view model via signaling.
    */
    public var updateProfile: Void -> Stream<Bool> {
        return {
            if let currentUser = self.userService.currentUser() {
                
                // Make sure all inputs are valid
                return self.AllInputsValidProduer()
                    // FlatMap to all inputs
                    |> flatMap { success -> Stream<[AnyObject?]> in
//                        let valid = success as! Bool
                        if success! {
                            // Combine all inputs
                            return [
                                    self.transformedNicknameProducer() |> map { $0 as? AnyObject },
                                    self.transformedBirthdayProducer() |> map { $0 as? AnyObject },
                                    self.transformedProfileImageProducer() |> map { $0 as? AnyObject }
                                ]
                                |> zipAll
                        }
                        else {
                            return Stream.error(NSError(domain: "SignUpViewModel", code: 899, userInfo: nil))
                        }
                    }
                    // Initiate network request
                    |> flatMap { values in
                        let imageData = UIImagePNGRepresentation(values[2] as? UIImage)
                        let file = AVFile.fileWithName("profile.png", data: imageData) as! AVFile
                        
                        currentUser.nickname = values[0] as? String
                        currentUser.birthday = values[1] as? NSDate
                        currentUser.profileImg = file
                        
                        return Stream<Bool>.fromTask(self.userService.save(currentUser))
                    }
                    // Logging
                    |> peek { _ in AccountLogVerbose("Request sent!") }
            }
            else {
                AccountLogError("Function called while user is not logged in")
                return Stream<Bool>.error(NSError(domain: "SignUpViewModel", code: 899, userInfo: nil))
            }
        }
    }
    
    /// Age restriction.
    public var ageLimit: AgeLimit {
        func calDate(currentDate: NSDate, age: Int) -> NSDate {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: currentDate)
            let currentYear = components.year
            let currentMonth = components.month
            let currentDay = components.day
            
            let ageComponents = NSDateComponents()
            ageComponents.year = currentYear - age
            ageComponents.month = currentMonth
            ageComponents.day = currentDay
            return calendar.dateFromComponents(ageComponents)!
        }
        
        // Restrict birthdays
        let currentDate = NSDate()
        
        return (floor: calDate(currentDate, MAX_AGE), ceil: calDate(currentDate, MIN_AGE))
    }
    
    // MARKL - Private Methods
    
    /**
    Check whether age is within the restriction
    
    :param: age The age
    
    :returns: Bool value indicating validity.
    */
    private func isValidAge(age: NSDate) -> Bool {
        let ageLimit = self.ageLimit
        
        // elder than minimum age
        let r1 = age.compare(ageLimit.ceil) == .OrderedAscending
        
        // younger than maximum age
        let r2 = age.compare(ageLimit.floor) == .OrderedDescending
        
        return r1 && r2
    }

}