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

public final class AccountViewModel : NSObject, IAccountViewModel {
    
    private let userService: IUserService
    public var birthday: NSDate?
    public var nickname: NSString?
    public var profileImage: UIImage?
    
    private var birthdaySignal: Stream<NSDate?>!
    private var nicknameSignal: Stream<NSString?>!
    private var profileImageSignal: Stream<UIImage?>!
    
    public var areValidInputSignal: Stream<NSNumber?>!
    
    public required init(userService: IUserService) {
        self.userService = userService
        
        super.init()
        
        birthdaySignal = KVO.stream(self, "birthday")
            |> asStream(NSDate?)
        nicknameSignal = KVO.stream(self, "nickname")
            |> asStream(NSString?)
        profileImageSignal = KVO.stream(self, "profileImage")
            |> asStream(UIImage?)
        
        
        areValidInputSignal = [
            nicknameSignal
                // starting value as false
                |> map { value -> Bool in
                    println(value)
                    return value!.length > 0
                }
                |> startWith(false),
            
            birthdaySignal
                |> map { date -> Bool in
                    // Restrict birthdays
                    let currentDate = NSDate()
                    let calendar = NSCalendar.currentCalendar()
                    let components = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: currentDate)
                    let currentYear = components.year
                    let currentMonth = components.month
                    let currentDay = components.day
                    
                    let maximumAgeComponents = NSDateComponents()
                    maximumAgeComponents.year = currentYear - 17
                    maximumAgeComponents.month = currentMonth
                    maximumAgeComponents.day = currentDay
                    let maximumDate = calendar.dateFromComponents(maximumAgeComponents)
                    
                    let minimumAgeComponents = NSDateComponents()
                    minimumAgeComponents.year = currentYear - 90
                    minimumAgeComponents.month = currentMonth
                    minimumAgeComponents.day = currentDay
                    let minimumDate = calendar.dateFromComponents(minimumAgeComponents)
                    
                    return date!.compare(minimumDate!) == .OrderedDescending && date!.compare(maximumDate!) == .OrderedAscending
                }
                |> startWith(false),
            
            profileImageSignal
                |> map { _ in return true }
                |> startWith(false)
        ]
            |> merge2All
            |> map { (values, changedValues) -> NSNumber? in
                if let v0 = values[0], v1 = values[1], v2 = values[2] {
                    return v0 && v1 && v2
                }
                return false
            }
    }
    
    public func updateProfile(nickname: String, birthday: NSDate, profileImage: UIImage?) -> Task<Int, Bool, NSError> {
        let currentUser = userService.currentUser()!
        currentUser.birthday = birthday
        currentUser.nickname = nickname
        let imageData = UIImagePNGRepresentation(profileImage)
        return userService.save(currentUser)
    }
}














