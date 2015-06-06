//
//  ASLFormatter.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import CocoaLumberjack.DDDispatchQueueLogFormatter

internal final class ASLFormatter: DDDispatchQueueLogFormatter, DDLogFormatter {
    
    internal override func formatLogMessage(logMessage: DDLogMessage!) -> String {
        var logLevel: String
        let logFlag = logMessage.flag
        if logFlag & .Error == .Error {
            logLevel = "E"
        } else if logFlag & .Warning == .Warning {
            logLevel = "W"
        } else if logFlag & .Info == .Info {
            logLevel = "I"
        } else if logFlag & .Debug == .Debug {
            logLevel = "D"
        } else if logFlag & .Verbose == .Verbose {
            logLevel = "V"
        } else {
            logLevel = "?"
        }
        
        let formattedLog = "|\(logLevel)| [\(logMessage.queueLabel) \(logMessage.threadID)] [\(logMessage.fileName) \(logMessage.function)] #\(logMessage.line): \(logMessage.message)"
        
        return formattedLog
    }
}
