//
//  MeRepository.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-21.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public protocol IMeRepository {
    
//    func findHoldingAndAttendingEvents() -> SignalProducer<[Event], NetworkError>
    /**
     Update my profile information.
     
     - parameter nickname:   My nickname
     - parameter whatsUp:    My What's Up
     - parameter coverPhoto: My primary cover image
     
     - returns: A SignalProducer of sequence of operation status.
     */
    func updateProfile(nickname: String?, whatsUp: String?, coverPhoto: UIImage?) -> SignalProducer<Bool, NetworkError>
    
    /**
     Update my password.
     
     - parameter newPassword: The new password
     
     - returns: A SignalProducer of sequence of operation status.
     */
//    func updatePassword(newPassword: String) -> SignalProducer<Bool, NetworkError>
    
    func signUp(username: String, password: String, nickname: String, birthday: NSDate, gender: Gender, profileImage: UIImage) -> SignalProducer<Bool, NetworkError>
    
    func logIn(username: String, password: String) -> SignalProducer<Me, NetworkError>
    
    func me() -> Me?
}

public final class MeRepository : _BaseRepository<Me, UserDAO>, IMeRepository {
    
    private let daoToModelMapper: UserDAO -> Me = { $0.toMe() }
    
    private let geolocationService: IGeoLocationService
    
    public init(geolocationService: IGeoLocationService) {
        self.geolocationService = geolocationService
        
        super.init(daoToModelMapper: { $0.toMe() })
    }
    
    public func updateProfile(nickname: String? = nil, whatsUp: String? = nil, coverPhoto: UIImage? = nil) -> SignalProducer<Bool, NetworkError> {
        let user = UserDAO()
        
        if let nickname = nickname {
            user.nickname = nickname
        }
        
        user.whatsUp = whatsUp
        
        if let coverPhoto = coverPhoto {
            let imageData = UIImagePNGRepresentation(coverPhoto)
            user.coverPhoto = AVFile(name: "profile.png", data: imageData)
        }
        
        return user.rac_save()
        
    }
    
//    public func updatePassword(newPassword: String) -> SignalProducer<Bool, NetworkError> {
//        
//    }
    
    public func signUp(username: String, password: String, nickname: String, birthday: NSDate, gender: Gender, profileImage: UIImage) -> SignalProducer<Bool, NetworkError> {
        let user = UserDAO()
        
        user.username = username
        user.password = password
        user.nickname = nickname
        user.birthday = birthday
        let imageData = UIImagePNGRepresentation(profileImage)
        user.coverPhoto = AVFile(name: "profile.png", data: imageData)
        user.gender = gender.rawValue
        
        return user.rac_signUp()
    }
    
    public func logIn(username: String, password: String) -> SignalProducer<Me, NetworkError> {
        
        return UserDAO.rac_logInWithUsername(username, password: password)
            .mapToMeModel()
    }
    
    public func me() -> Me? {
        let t = UserDAO.currentUser()
        guard let currentUser = UserDAO.currentUser() where currentUser.isAuthenticated() else {
            return nil
        }
        return currentUser.toMe()
    }
    
    public func logOut() {
        UserDAO.logOut()
    }
}
