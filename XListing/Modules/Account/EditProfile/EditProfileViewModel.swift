//
//  SignUpViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public struct EditProfileViewModel {
    // MARK: - Public
    public typealias AgeLimit = (floor: NSDate, ceil: NSDate)
    
    // MARK: Input
    public let nickname = MutableProperty<String>("")
    public let birthday = MutableProperty<NSDate>(NSDate())
    public let profileImage = MutableProperty<UIImage?>(nil)
    
    // MARK: Output
    public let allInputsValid = MutableProperty<Bool>(false)
    
    // MARK: Actions
    public var updateProfile: SignalProducer<Bool, NSError> {
        return self.allInputsValid.producer
            // only allow TRUE value
            |> filter { $0 }
            |> mapError { _ in NSError() }
            |> flatMap(FlattenStrategy.Merge) { _ -> SignalProducer<User, NSError> in
                return self.userService.currentLoggedInUser()
            }
            |> flatMap(FlattenStrategy.Merge) { user -> SignalProducer<Bool, NSError> in
                
                let imageData = UIImagePNGRepresentation(self.profileImage.value)
                let file = AVFile.fileWithName("profile.png", data: imageData) as! AVFile
                
                user.nickname = self.nickname.value
                user.birthday = self.birthday.value
                user.profileImg = file
                return self.userService.save(user)
        }
    }
    
    // MARK: API
    public func dismissAccountView() {
        router.pushFeatured()
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
    
    // MARK: Initializers
    
    public init(userService: IUserService, router: IRouter) {
        self.userService = userService
        self.router = router
        
        setupNickname()
        setupBirthday()
        setupProfileImage()
        setupAllInputsValid()
    }
    
    // MARK: - Private
    private var isNicknameValid = MutableProperty<Bool>(false)
    private var isBirthdayValid = MutableProperty<Bool>(false)
    private var isProfileImageValid = MutableProperty<Bool>(false)
    
    // MARK: Services
    private let userService: IUserService
    private let router: IRouter
    
    // MARK: Setup
    
    private func setupNickname() {
        isNicknameValid <~ nickname.producer
            // TODO: regex
            |> filter { count($0) > 0 }
            |> map { _ in return true }
    }
    
    private func setupBirthday() {
        isBirthdayValid <~ birthday.producer
            |> map { self.isValidAge($0) }
    }
    
    private func setupProfileImage() {
        isProfileImageValid <~ profileImage.producer
            |> map { $0 == nil ? false : true }
    }
    
    private func setupAllInputsValid() {
        allInputsValid <~ combineLatest(isNicknameValid.producer, isBirthdayValid.producer, isProfileImageValid.producer)
            |> on(next: { value in AccountLogDebug("(\(value.0) \(value.1) \(value.2))") })
            |> map { values -> Bool in
                return values.0 && values.1 && values.2
            }
    }
    
    // MARK: Private Methods
    
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