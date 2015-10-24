//
//  Horoscope.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public enum Horoscope : Int, Printable {
    
    case Capricorn = 1, Aquarius, Pisces, Aries, Taurus, Gemini, Cancer, Leo, Virgo, Libra, Scorpio, Sagittarius
    
    public var value: String {
        switch self {
        case .Capricorn:
            return "摩羯座"
        case .Aquarius:
            return "水瓶座"
        case .Pisces:
            return "双鱼座"
        case .Aries:
            return "白羊座"
        case .Taurus:
            return "金牛座"
        case .Gemini:
            return "双子座"
        case .Cancer:
            return "巨蟹座"
        case .Leo:
            return "狮子座"
        case .Virgo:
            return "处女座"
        case .Libra:
            return "天秤座"
        case .Scorpio:
            return "天蝎座"
        case .Sagittarius:
            return "射手座"
        }
    }
    
    public var description: String {
        switch self {
        case .Capricorn:
            return "Capricorn"
        case .Aquarius:
            return "Aquarius"
        case .Pisces:
            return "Pisces"
        case .Aries:
            return "Aries"
        case .Taurus:
            return "Taurus"
        case .Gemini:
            return "Gemini"
        case .Cancer:
            return "Cancer"
        case .Leo:
            return "Leo"
        case .Virgo:
            return "Virgo"
        case .Libra:
            return "Libra"
        case .Scorpio:
            return "Scorpio"
        case .Sagittarius:
            return "Sagittarius"
        }
    }
}