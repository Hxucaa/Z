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
    public let gender = MutableProperty<Gender?>(nil)
    
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
                user.gender = self.gender.value?.rawValue
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
        setupGender()
        setupBirthday()
        setupProfileImage()
        setupAllInputsValid()
    }
    
    // MARK: - Private
    private var isNicknameValid = MutableProperty<Bool>(false)
    private var isBirthdayValid = MutableProperty<Bool>(false)
    private var isProfileImageValid = MutableProperty<Bool>(false)
    private var isGenderValid = MutableProperty<Bool>(false)
    
    private let symbols = "~`!@#$%^&*()-_+={[}]|\\:;\"'<,>.?/"
    private let chinese = "\\p{script=Han}"
    private let emoji = "\u{00A9}\u{00AE}\u{203C}\u{2049}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{2328}\u{23CF}\u{23E9}-\u{23F3}\u{23F8}-\u{23FA}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2604}\u{260E}\u{2611}\u{2614}-\u{2615}\u{2618}\u{261D}\u{2620}\u{2622}-\u{2623}\u{2626}\u{262A}\u{262E}-\u{262F}\u{2638}-\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2692}-\u{2694}\u{2696}-\u{2697}\u{2699}\u{269B}-\u{269C}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26B0}-\u{26B1}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26C8}\u{26CE}-\u{26CF}\u{26D1}\u{26D3}-\u{26D4}\u{26E9}-\u{26EA}\u{26F0}-\u{26F5}\u{26F7}-\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270D}\u{270F}\u{2712}\u{2714}\u{2716}\u{271D}\u{2721}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2763}-\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{27BF}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F321}\u{1F324}-\u{1F393}\u{1F396}-\u{1F397}\u{1F399}-\u{1F39B}\u{1F39E}-\u{1F3F0}\u{1F3F3}-\u{1F3F5}\u{1F3F7}-\u{1F4FD}\u{1F4FF}-\u{1F53D}\u{1F549}-\u{1F54E}\u{1F550}-\u{1F567}\u{1F56F}-\u{1F570}\u{1F573}-\u{1F579}\u{1F587}\u{1F58A}-\u{1F58D}\u{1F590}\u{1F595}-\u{1F596}\u{1F5A5}\u{1F5A8}\u{1F5B1}-\u{1F5B2}\u{1F5BC}\u{1F5C2}-\u{1F5C4}\u{1F5D1}-\u{1F5D3}\u{1F5DC}-\u{1F5DE}\u{1F5E1}\u{1F5E3}\u{1F5EF}\u{1F5F3}\u{1F5FA}-\u{1F64F}\u{1F680}-\u{1F6C5}\u{1F6CB}-\u{1F6D0}\u{1F6E0}-\u{1F6E5}\u{1F6E9}\u{1F6EB}-\u{1F6EC}\u{1F6F0}\u{1F6F3}\u{1F910}-\u{1F918}\u{1F980}-\u{1F984}\u{1F9C0}"
    
    
    // MARK: Services
    private let userService: IUserService
    private let router: IRouter
    
    // MARK: Setup
    
    private func setupNickname() {
        // only allow nicknames with:
        // - between 3 and 15 characters
        // - emoji, letters, numbers, chinese characters, and standard symbols only
        isNicknameValid <~ nickname.producer
            |> filter { self.testRegex($0, pattern: "^([\(self.symbols)]|[\(self.chinese)]|[\(self.emoji)]|[A-Za-z\\d]){3,15}$")}
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
    
    private func setupGender() {
        isGenderValid <~ gender.producer
            |> map { $0 == nil ? false : true }
    }

    
    private func setupAllInputsValid() {
        allInputsValid <~ combineLatest(isNicknameValid.producer, isBirthdayValid.producer, isProfileImageValid.producer,
            isGenderValid.producer)
            |> on(next: { value in AccountLogDebug("(\(value.0) \(value.1) \(value.2) \(value.3))") })
            |> map { values -> Bool in
                return values.0 && values.1 && values.2 && values.3
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
    
    private func testRegex(input: String, pattern: String) -> Bool {
        let regex = NSRegularExpression(pattern: pattern, options: nil, error: nil)
        let matches = regex!.matchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
        return matches.count == 1
    }
}