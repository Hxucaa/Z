//
//  ConsoleFormatter.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import CocoaLumberjack.DDDispatchQueueLogFormatter
//, DDLogFormatter
internal final class ConsoleFormatter: DDDispatchQueueLogFormatter {
    private let threadUnsafeDateFormatter: NSDateFormatter
    
    internal override init() {
        // On iOS 7 and later NSDateFormatter is thread safe.
        threadUnsafeDateFormatter = NSDateFormatter()
        threadUnsafeDateFormatter.formatterBehavior = .Behavior10_4
        threadUnsafeDateFormatter.dateFormat = "HH:mm:ss.SSS"
        
        super.init()
    }
    
    internal override func formatLogMessage(logMessage: DDLogMessage!) -> String {
        let dateAndTime = threadUnsafeDateFormatter.stringFromDate(logMessage.timestamp)
        
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
        
        let formattedLog = "\(dateAndTime) |\(logLevel)| [\(logMessage.fileName) \(logMessage.function)] #\(logMessage.line): \(logMessage.message)"
        
        return formattedLog
    }
}