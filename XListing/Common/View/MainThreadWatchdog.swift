//
//  MainThreadWatchdog.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
#if DEBUG
    import Watchdog
#endif

public final class MainThreadWatchdog {
    private var watchdog: Watchdog?
        
    public func startMonitoring() {
        #if DEBUG
            watchdog = Watchdog(threshold: 0.2) { (duration) -> () in
                MiscLogDebug("👮 Main thread was blocked for " + String(format:"%.2f", duration) + "s 👮")
            }
        #endif
    }
    
    public func stopMonitoring() {
        #if DEBUG
            watchdog = nil
        #endif
    }
}