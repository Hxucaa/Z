//
//  TemporaryHolding.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public func convertHoroscope(horoscope: Horoscope?) -> String {
    if let horoscope = horoscope {
        switch horoscope {
        case .Aries: return "♈️" + "白羊座"
        case .Taurus: return "♉️" + "金牛座"
        case .Gemini: return "♊️" + "双子座"
        case .Cancer: return "♋️" + "巨蟹座"
        case .Leo: return "♌️" + "狮子座"
        case .Virgo: return "♍️" + "处女座"
        case .Libra: return "♎️" + "天秤座"
        case .Scorpio: return "♏️" + "天蝎座"
        case .Sagittarius: return "♐️" + "射手座"
        case .Capricorn: return "♑️" + "摩羯座"
        case .Aquarius: return "♒️" + "水瓶座"
        case .Pisces: return "♓️" + "双鱼座"
        }
    }
    else {
        return ""
    }
}

public func convertParticipationType(type: ParticipationType?) -> String {
    if let type = type {
        switch type {
        case .AA: return "AA"
        case .Treat: return "请客"
        case .ToGo: return "想去"
        }
    }
    else {
        return ""
    }
}

public func convertAgeGroup(ageGroup: AgeGroup?) -> String {
    if let ageGroup = ageGroup {
        switch ageGroup {
        case .五零后: return "50 后"
        case .六零后: return "60 后"
        case .七零后: return "70 后"
        case .八零后: return "80 后"
        case .九零后: return "90 后"
        case .零零后: return "00 后"
        case .一零后: return "10 后"
        }
    }
    else {
        return ""
    }
}