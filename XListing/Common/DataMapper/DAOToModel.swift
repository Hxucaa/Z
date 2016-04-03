//
//  DAOToModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud
import ReactiveCocoa

extension Gender {
    init?(attribute: Attribute<Int>) {
        switch attribute.value {
        case 1: self = .Male
        case 0: self = .Female
        default: return nil
        }
    }
}

extension Horoscope {
    init?(attribute: Attribute<Int>) {
        switch attribute.value {
        case 1: self = .Capricorn
        case 2: self = .Aquarius
        case 3: self = .Pisces
        case 4: self = .Aries
        case 5: self = .Taurus
        case 6: self = .Gemini
        case 7: self = .Cancer
        case 8: self = .Leo
        case 9: self = .Virgo
        case 10: self = .Libra
        case 11: self = .Scorpio
        case 12: self = .Sagittarius
        default: return nil
        }
    }
}

extension AgeGroup {
    init?(attribute: Attribute<Int>) {
        switch attribute.value {
        case 1: self = .Group10
        case 2: self = .Group20
        case 3: self = .Group30
        case 4: self = .Group40
        case 5: self = .Group50
        case 6: self = .Group60
        case 7: self = .Group70
        case 8: self = .Group80
        case 9: self = .Group90
        case 10: self = .Group100
        case 11: self = .Group110
        case 12: self = .Group120
        default: return nil
        }
    }
}

extension Activation {
    init(attribute: Attribute<Bool>) {
        if attribute.value {
            self = .Active
        }
        else {
            self = .InActive
        }
    }
}


extension UserType {
    init?(attribute: Attribute<Int>) {
        switch attribute.value {
        case 1: self = .User
        case 2: self = .Business
        default: return nil
        }
    }
}

extension UserStatus {
    init?(attribute: Attribute<Int>) {
        switch attribute.value {
        case 0: self = .NotRegistered
        case 1: self = .Registered
        case 2: self = .Locked
        case 3: self = .ForgotPassword
        case 4: self = .Disable
        default: return nil
        }
    }
}

extension EventType {
    init?(attribute: Attribute<Int>) {
        switch attribute.value {
        case 1: self = .Treat
        case 2: self = .Split
        case 3: self = .ToGo
        default: return nil
        }
    }
}

extension EventStatus {
    init?(attribute: Attribute<Int>) {
        switch attribute.value {
        case 1: self = .Open
        case 2: self = .Started
        default: return nil
        }
    }
}

extension EventParticipationStatus {
    init?(attribute: Attribute<Int>) {
        switch attribute.value {
        case 8: self = .Joined
        default: return nil
        }
    }
}




extension ImageFile {
    init(attribute: Attribute<AVFile>) {
        name = attribute.value.name
        url = NSURL(string: attribute.value.url)
        
    }
}

extension SignalProducer where Value : AVObject {
    func mapToModel<M: IModel>(transform: Value -> M) -> SignalProducer<M, Error> {
        return self.map(transform)
    }
    
    func mapToDAO<DAO: AVObject>(type: DAO.Type) -> SignalProducer<DAO, Error> {
        return self.map { $0 as! DAO }
    }
}

extension SignalProducer where Value : EventDAO {
    func mapToEventModel() -> SignalProducer<Event, Error> {
        return self.map { $0.toEvent() }
    }
}

extension SignalProducer where Value : BusinessDAO {
    func mapToBusinessModel() -> SignalProducer<Business, Error> {
        return self.map { $0.toBusiness() }
    }
}

extension SignalProducer where Value : UserDAO {
    func mapToUserModel() -> SignalProducer<User, Error> {
        return self.map { $0.toUser() }
    }
    
    func mapToMeModel() -> SignalProducer<Me, Error> {
        return self.map { $0.toMe() }
    }
}

extension SignalProducer where Value : SequenceType, Value.Generator.Element : AVObject {
    func mapToModel<M: IModel>(transform: Value.Generator.Element -> M) -> SignalProducer<[M], Error> {
        return self.map { $0.map(transform) }
    }
}

extension Array where Element : AVObject {
    func mapToModel<M: IModel>(@noescape transform: Array.Generator.Element throws -> M) rethrows -> [M] {
        return try self.map(transform)
    }
}

import RxSwift

extension Observable where Element : SequenceType, Element.Generator.Element : AVObject {
    func mapToModel<M: IModel>(transform: Element.Generator.Element -> M) -> Observable<[M]> {
        return self.map { $0.map(transform) }
    }
}

extension Observable where Element : UserDAO {
    func mapToUserModel() -> Observable<User> {
        return self.map { $0.toUser() }
    }
    
    func mapToMeModel() -> Observable<Me> {
        return self.map { $0.toMe() }
    }
}


extension Observable where Element : AVObject {
    func mapToModel<M: IModel>(transform: Element -> M) -> Observable<M> {
        return self.map(transform)
    }
    
    func mapToDAO<DAO: AVObject>(type: DAO.Type) -> Observable<DAO> {
        return self.map { $0 as! DAO }
    }
}

extension Observable where Element : EventDAO {
    func mapToEventModel() -> Observable<Event> {
        return self.map { $0.toEvent() }
    }
}

extension Observable where Element : BusinessDAO {
    func mapToBusinessModel() -> Observable<Business> {
        return self.map { $0.toBusiness() }
    }
}

extension UserDAO {
    
    func toUser() -> User {
        assert(UserType(rawValue: self.type) == UserType.User, "The type of User does not match.")
        return User(
            objectId: self.objectId,
            updatedAt: self.updatedAt,
            createdAt: self.createdAt,
            status: UserStatus(rawValue: self.status)!,
            nickname: self.nickname,
            gender: Gender(rawValue: self.gender)!,
            ageGroup: AgeGroup(rawValue: self.ageGroup)!,
            horoscope: Horoscope(rawValue: self.horoscope)!,
            coverPhoto: self.coverPhoto?.toImageFile(),
            whatsUp: self.whatsUp,
            latestLocation: self.latestLocation?.toGeolocation(),
            aaCount: self.aaCount,
            treatCount: self.treatCount,
            toGoCount: self.toGoCount
        )
    }
    
    func toBusinessUser() -> BusinessUser {
        assert(UserType(rawValue: self.type) == UserType.Business, "The type of User does not match.")
        return BusinessUser(
            objectId: self.objectId,
            updatedAt: self.updatedAt,
            createdAt: self.createdAt,
            status: UserStatus(rawValue: self.status)!,
            nickname: self.nickname,
            gender: Gender(rawValue: self.gender)!,
            ageGroup: AgeGroup(rawValue: self.ageGroup)!,
            horoscope: Horoscope(rawValue: self.horoscope)!,
            coverPhoto: self.coverPhoto?.toImageFile(),
            whatsUp: self.whatsUp,
            latestLocation: self.latestLocation?.toGeolocation(),
            aaCount: self.aaCount,
            treatCount: self.treatCount,
            toGoCount: self.toGoCount
        )
    }
    
    func toMe() -> Me {
        assert(UserType(rawValue: self.type) == UserType.User, "The type of User does not match.")
        return Me(
            objectId: self.objectId,
            updatedAt: self.updatedAt,
            createdAt: self.createdAt,
            birthday: self.birthday,
            address: self.address?.toAddress(),
            status: UserStatus(rawValue: self.status)!,
            nickname: self.nickname,
            gender: Gender(rawValue: self.gender)!,
            ageGroup: AgeGroup(rawValue: self.ageGroup)!,
            horoscope: Horoscope(rawValue: self.horoscope)!,
            coverPhoto: self.coverPhoto?.toImageFile(),
            whatsUp: self.whatsUp,
            latestLocation: self.latestLocation?.toGeolocation(),
            aaCount: self.aaCount,
            treatCount: self.treatCount,
            toGoCount: self.toGoCount
        )
    }
    
}

extension AddressDAO {
    func toAddress() -> Address {
        return Address(
            objectId: self.objectId,
            updatedAt: self.updatedAt,
            createdAt: self.createdAt,
            street: self.street,
            district: District(code: self.regionCode),
            city: City(code: self.regionCode),
            province: Province(code: self.regionCode),
            postalCode: self.postalCode,
            geoLocation: Geolocation(latitude: self.geoLocation.latitude, longitude: self.geoLocation.longitude),
            fullAddress: self.fullAddress
        )
    }
}


extension BusinessDAO {
    
    public func toBusiness() -> Business {
        return Business(
            objectId: self.objectId,
            updatedAt: self.updatedAt,
            createdAt: self.createdAt,
            name: self.name,
            phone: self.phone,
            email: self.email,
            websiteUrl: self.websiteUrl?.toNSURL(),
            address: self.address.toAddress(),
            coverImage: ImageFile(name: self.coverImage.name, url: NSURL(string: self.coverImage.url)),
            descriptor: self.descript,
            aaCount: self.aaCount,
            treatCount: self.treatCount,
            toGoCount: self.toGoCount
        )
    }
}

extension EventDAO {
    
    func toEvent() -> Event {
        return Event(
            objectId: self.objectId,
            updatedAt: self.updatedAt,
            createdAt: self.createdAt,
            initiator: self.initiator.toUser(),
            business: self.business.toBusiness(),
            finalParticipant: self.initiator.toUser(),
            type: EventType(attribute: self.type)!,
            status: EventStatus(attribute: self.status)!
        )
    }
}

extension EventParticipationDAO {
    func toEventParticipation() -> EventParticipation {
        return EventParticipation(
            objectId: self.objectId,
            updatedAt: self.updatedAt,
            createdAt: self.createdAt,
            participant: self.participant.toUser(),
            event: self.event.toEvent(),
            status: EventParticipationStatus(attribute: self.status)!
        )
    }
}

extension String {
    func toNSURL() -> NSURL? {
        return NSURL(string: self)
    }
}

extension AVFile {
    func toImageFile() -> ImageFile {
        return ImageFile(name: self.name, url: NSURL(string: self.url))
    }
}

extension AVGeoPoint {
    func toGeolocation() -> Geolocation {
        return Geolocation(latitude: self.latitude, longitude: self.longitude)
    }
}

extension NSError {
    func toNetworkError() -> NetworkError {
        precondition(self.domain == "AVOS Cloud Error Domain", "You can only convert NSError objects constructed by AVOSCloud to NetworkError.")
        let error = NetworkError(rawValue: self.code)
        assert(error != nil, "All cases of error produced by AVOSCloud must be covered.")
        return error!
    }
}
