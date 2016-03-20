//
//  DataMapper.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

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
    func toBusiness() -> Business {
        return Business(
            objectId: self.objectId,
            updatedAt: self.updatedAt,
            createdAt: self.createdAt,
            name: self.name,
            phone: self.phone,
            email: self.email,
            websiteUrl: self.websiteUrl?.toNSURL(),
            address: self.address.toAddress(),
            coverImage: ImageFile(name: self.coverImage.name, url: self.coverImage.url),
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
            type: EventType(rawValue: self.event_type)!,
            status: EventStatus(rawValue: self.status)!
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
            status: EventParticipationStatus(rawValue: self.status)!
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
        return ImageFile(name: self.name, url: self.url)
    }
}

extension AVGeoPoint {
    func toGeolocation() -> Geolocation {
        return Geolocation(latitude: self.latitude, longitude: self.longitude)
    }
}
