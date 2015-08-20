// Software License Agreement (BSD License)
//
// Copyright (c) 2014-2015, Deusty, LLC
// All rights reserved.
//
// Redistribution and use of this software in source and binary forms,
// with or without modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// * Neither the name of Deusty nor the names of its contributors may be used
//   to endorse or promote products derived from this software without specific
//   prior written permission of Deusty, LLC.

import Foundation
import CocoaLumberjack

extension DDLogFlag {
    public static func fromLogLevel(logLevel: DDLogLevel) -> DDLogFlag {
        return DDLogFlag(logLevel.rawValue)
    }
    
    ///returns the log level, or the lowest equivalant.
    public func toLogLevel() -> DDLogLevel {
        if let ourValid = DDLogLevel(rawValue: self.rawValue) {
            return ourValid
        } else {
            let logFlag = self
            if logFlag & .Verbose == .Verbose {
                return .Error
            } else if logFlag & .Debug == .Debug {
                return .Debug
            } else if logFlag & .Info == .Info {
                return .Info
            } else if logFlag & .Warning == .Warning {
                return .Warning
            } else if logFlag & .Error == .Error {
                return .Verbose
            } else {
                return .Off
            }
        }
    }
}

/********************************
*                               *
*       Logging Contexts        *
*                               *
*********************************/

public enum LogContext : Int {
    case LeanCloud = 800
    case Misc = 700
    case Root = 100
    case BackgroundOp = 200
    case Account = 300
    case Detail = 310
    case Nearby = 320
    case Featured = 330
    case Profile = 340
    case WantToGo = 350
    case Other = 0
}

public var defaultDebugLevel = DDLogLevel.Verbose

public func resetDefaultDebugLevel() {
    defaultDebugLevel = DDLogLevel.Verbose
}

public func SwiftLogMacro(isAsynchronous: Bool, level: DDLogLevel, flag flg: DDLogFlag, context: LogContext = LogContext.Other, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UInt = __LINE__, tag: AnyObject? = nil, @autoclosure(escaping) #string: () -> String) {
    if level.rawValue & flg.rawValue != 0 {
        // Tell the DDLogMessage constructor to copy the C strings that get passed to it. Using string interpolation to prevent integer overflow warning when using StaticString.stringValue
        let logMessage = DDLogMessage(message: string(), level: level, flag: flg, context: context.rawValue, file: "\(file)", function: "\(function)", line: line, tag: tag, options: .CopyFile | .CopyFunction, timestamp: nil)
        DDLog.log(isAsynchronous, message: logMessage)
    }
}

public func DDLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = true) {
    SwiftLogMacro(async, level, flag: .Debug, file: file, function: function, line: line, string: logText)
}

public func DDLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = true) {
    SwiftLogMacro(async, level, flag: .Info, file: file, function: function, line: line, string: logText)
}

public func DDLogWarn(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = true) {
    SwiftLogMacro(async, level, flag: .Warning, file: file, function: function, line: line, string: logText)
}

public func DDLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = true) {
    SwiftLogMacro(async, level, flag: .Verbose, file: file, function: function, line: line, string: logText)
}

public func DDLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       LeanCloud Service       *
*                               *
*********************************/

public func LSLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: .LeanCloud, file: file, function: function, line: line, string: logText)
}

public func LSLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: .LeanCloud, file: file, function: function, line: line, string: logText)
}

public func LSLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: .LeanCloud, file: file, function: function, line: line, string: logText)
}

public func LSLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: .LeanCloud, file: file, function: function, line: line, string: logText)
}

public func LSLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: .LeanCloud, file: file, function: function, line: line, string: logText)
}


/********************************
*                               *
*   Background Operations       *
*                               *
*********************************/

public func BOLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: LogContext.BackgroundOp, file: file, function: function, line: line, string: logText)
}

public func BOLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: LogContext.BackgroundOp, file: file, function: function, line: line, string: logText)
}

public func BOLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: LogContext.BackgroundOp, file: file, function: function, line: line, string: logText)
}

public func BOLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: LogContext.BackgroundOp, file: file, function: function, line: line, string: logText)
}

public func BOLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: LogContext.BackgroundOp, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Account                 *
*                               *
*********************************/

public func AccountLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: .Account, file: file, function: function, line: line, string: logText)
}

public func AccountLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: .Account, file: file, function: function, line: line, string: logText)
}

public func AccountLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: .Account, file: file, function: function, line: line, string: logText)
}

public func AccountLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: .Account, file: file, function: function, line: line, string: logText)
}

public func AccountLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: .Account, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Detail                  *
*                               *
*********************************/

public func DetailLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: .Detail, file: file, function: function, line: line, string: logText)
}

public func DetailLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: .Detail, file: file, function: function, line: line, string: logText)
}

public func DetailLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: .Detail, file: file, function: function, line: line, string: logText)
}

public func DetailLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: .Detail, file: file, function: function, line: line, string: logText)
}

public func DetailLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: .Detail, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Nearby                  *
*                               *
*********************************/

public func NearbyLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: .Nearby, file: file, function: function, line: line, string: logText)
}

public func NearbyLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: .Nearby, file: file, function: function, line: line, string: logText)
}

public func NearbyLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: .Nearby, file: file, function: function, line: line, string: logText)
}

public func NearbyLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: .Nearby, file: file, function: function, line: line, string: logText)
}

public func NearbyLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: .Nearby, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Featured                *
*                               *
*********************************/

public func FeaturedLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: .Featured, file: file, function: function, line: line, string: logText)
}

public func FeaturedLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: .Featured, file: file, function: function, line: line, string: logText)
}

public func FeaturedLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: .Featured, file: file, function: function, line: line, string: logText)
}

public func FeaturedLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: .Featured, file: file, function: function, line: line, string: logText)
}

public func FeaturedLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: .Featured, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Root                    *
*                               *
*********************************/

public func RootLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: .Root, file: file, function: function, line: line, string: logText)
}

public func RootLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: .Root, file: file, function: function, line: line, string: logText)
}

public func RootLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: .Root, file: file, function: function, line: line, string: logText)
}

public func RootLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: .Root, file: file, function: function, line: line, string: logText)
}

public func RootLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: .Root, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Profile                 *
*                               *
*********************************/

public func ProfileLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: .Profile, file: file, function: function, line: line, string: logText)
}

public func ProfileLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: .Profile, file: file, function: function, line: line, string: logText)
}

public func ProfileLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: .Profile, file: file, function: function, line: line, string: logText)
}

public func ProfileLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: .Profile, file: file, function: function, line: line, string: logText)
}

public func ProfileLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: .Profile, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       WantToGo                *
*                               *
*********************************/

public func WTGLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: .WantToGo, file: file, function: function, line: line, string: logText)
}

public func WTGLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: .WantToGo, file: file, function: function, line: line, string: logText)
}

public func WTGLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: .WantToGo, file: file, function: function, line: line, string: logText)
}

public func WTGLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: .WantToGo, file: file, function: function, line: line, string: logText)
}

public func WTGLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: .WantToGo, file: file, function: function, line: line, string: logText)
}


/********************************
*                               *
*       Misc                    *
*                               *
*********************************/

public func MiscLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: .Misc, file: file, function: function, line: line, string: logText)
}

public func MiscLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: .Misc, file: file, function: function, line: line, string: logText)
}

public func MiscLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: .Misc, file: file, function: function, line: line, string: logText)
}

public func MiscLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: .Misc, file: file, function: function, line: line, string: logText)
}

public func MiscLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: .Misc, file: file, function: function, line: line, string: logText)
}

/// Analogous to the C preprocessor macro THIS_FILE
public func CurrentFileName(fileName: StaticString = __FILE__) -> String {
    // Using string interpolation to prevent integer overflow warning when using StaticString.stringValue
    return "\(fileName)".lastPathComponent.stringByDeletingPathExtension
}