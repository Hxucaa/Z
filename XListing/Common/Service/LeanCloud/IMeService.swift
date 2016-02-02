//
//  IMeService.swift
//  XListing
//
//  Created by Hong Zhu on 2016-01-31.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IMeService : class {
    var currentUser: Me? { get }
    func isLoggedInAlready() -> Bool
    func currentLoggedInUser() -> SignalProducer<Me, NSError>
    func signUp(username: String, password: String, nickname: String, birthday: NSDate, gender: Gender, profileImage: UIImage) -> SignalProducer<Bool, NSError>
    func logIn(username: String, password: String) -> SignalProducer<Me, NSError>
    func logOut()
    func save(user: Me) -> SignalProducer<Bool, NSError>
}