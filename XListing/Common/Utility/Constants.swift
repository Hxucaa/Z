//
//  Constants.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

struct Constants {
    // HUD显示延迟时间，如键盘回收时需要短暂等待，否则HUD animation会有异常显示
    static let HUD_DELAY = 0.5
    // Pull To Refresh收回延迟时间，保证Pull To Refresh在网速很快情况下不会马上消失
    static let PULL_TO_REFRESH_DELAY = 1.0
    static let MIN_AGE = 17
    static let MAX_AGE = 90
}

public let LOGO_SCALE_BASE_FACTOR = 400.0


public let CITY_DISTANCE_SEPARATOR = "•"