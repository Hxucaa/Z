//
//  ASLFormatter.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import CocoaLumberjack.DDDispatchQueueLogFormatter
//, DDLogFormatter
internal final class ASLFormatter: DDDispatchQueueLogFormatter {
    
    internal override func formatLogMessage(logMessage: DDLogMessage!) -> String {
        var logLevel: String
        let logFlag = logMessage.flag
        if logFlag.contains(.Error) {
            logLevel = "E"
        } else if logFlag.contains(.Warning) {
            logLevel = "W"
        } else if logFlag.contains(.Info) {
            logLevel = "I"
        } else if logFlag.contains(.Debug) {
            logLevel = "D"
        } else if logFlag.contains(.Verbose) {
            logLevel = "V"
        } else {
            logLevel = "?"
        }
        
        let formattedLog = "|\(logLevel)| [\(logMessage.queueLabel) \(logMessage.threadID)] [\(logMessage.fileName) \(logMessage.function)] #\(logMessage.line): \(logMessage.message)"
        
        return formattedLog
    }
}
