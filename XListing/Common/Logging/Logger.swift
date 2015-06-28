//
//  Logger.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import CocoaLumberjack

internal final class Logger {
    internal class func configure() {
        let consoleFormatter = ConsoleFormatter()
        let aslFormatter = ASLFormatter()
        
        configConsoleLogger(consoleFormatter)
        configAppleSystemLogger(aslFormatter)
    }
    
    private class func configConsoleLogger(_ formatter: ConsoleFormatter? = nil) {
        let pink = UIColor(red: 255.0/255.0, green: 58.0/255.0, blue: 159.0/255.0, alpha: 1.0)
        let blue = UIColor(red: 135.0/255.0, green: 206.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        let logger = DDTTYLogger.sharedInstance()
        
        if let formatter = formatter {
            logger.logFormatter = formatter
        }
        
        // Enable log color in console
        logger.colorsEnabled = true
        
        // Set color for a log level
        logger.setForegroundColor(blue, backgroundColor: nil, forFlag: DDLogFlag.Info)
        logger.setForegroundColor(pink, backgroundColor: nil, forFlag: DDLogFlag.Debug)
        
        // Console log
        DDLog.addLogger(logger, withLevel: DDLogLevel.Verbose)
    }
    
    private class func configAppleSystemLogger(_ formatter: ASLFormatter? = nil) {
        let logger = DDASLLogger.sharedInstance()
        if let formatter = formatter {
            logger.logFormatter = formatter
        }
        
        DDLog.addLogger(logger, withLevel: DDLogLevel.Info)
    }
    
    private class func configFileLogger(_ formatter: ConsoleFormatter? = nil) {
        
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        if let formatter = formatter {
            fileLogger.logFormatter = formatter
        }
        
        DDLog.addLogger(fileLogger, withLevel: DDLogLevel.Info)
    }
}