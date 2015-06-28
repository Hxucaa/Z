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
private let LeanCloudService_Log_Context = 800
private let Root_Log_Context = 100
private let BackgroundOperations_Log_Context = 200
private let Account_Log_Context = 300
private let Detail_Log_Context = 310
private let Nearby_Log_Context = 320
private let Featured_Log_Context = 330
private let Profile_Log_Context = 340

public var defaultDebugLevel = DDLogLevel.Verbose

public func resetDefaultDebugLevel() {
    defaultDebugLevel = DDLogLevel.Verbose
}

public func SwiftLogMacro(isAsynchronous: Bool, level: DDLogLevel, flag flg: DDLogFlag, context: Int = 0, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UInt = __LINE__, tag: AnyObject? = nil, @autoclosure(escaping) #string: () -> String) {
    if level.rawValue & flg.rawValue != 0 {
        // Tell the DDLogMessage constructor to copy the C strings that get passed to it. Using string interpolation to prevent integer overflow warning when using StaticString.stringValue
        let logMessage = DDLogMessage(message: string(), level: level, flag: flg, context: context, file: "\(file)", function: "\(function)", line: line, tag: tag, options: .CopyFile | .CopyFunction, timestamp: nil)
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
    SwiftLogMacro(async, level, flag: .Debug, context: LeanCloudService_Log_Context, file: file, function: function, line: line, string: logText)
}

public func LSLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: LeanCloudService_Log_Context, file: file, function: function, line: line, string: logText)
}

public func LSLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: LeanCloudService_Log_Context, file: file, function: function, line: line, string: logText)
}

public func LSLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: LeanCloudService_Log_Context, file: file, function: function, line: line, string: logText)
}

public func LSLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: LeanCloudService_Log_Context, file: file, function: function, line: line, string: logText)
}


/********************************
*                               *
*   Background Operations       *
*                               *
*********************************/

public func BOLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: BackgroundOperations_Log_Context, file: file, function: function, line: line, string: logText)
}

public func BOLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: BackgroundOperations_Log_Context, file: file, function: function, line: line, string: logText)
}

public func BOLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: BackgroundOperations_Log_Context, file: file, function: function, line: line, string: logText)
}

public func BOLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: BackgroundOperations_Log_Context, file: file, function: function, line: line, string: logText)
}

public func BOLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: BackgroundOperations_Log_Context, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Account                 *
*                               *
*********************************/

public func AccountLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: Account_Log_Context, file: file, function: function, line: line, string: logText)
}

public func AccountLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: Account_Log_Context, file: file, function: function, line: line, string: logText)
}

public func AccountLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: Account_Log_Context, file: file, function: function, line: line, string: logText)
}

public func AccountLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: Account_Log_Context, file: file, function: function, line: line, string: logText)
}

public func AccountLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: Account_Log_Context, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Detail                  *
*                               *
*********************************/

public func DetailLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: Detail_Log_Context, file: file, function: function, line: line, string: logText)
}

public func DetailLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: Detail_Log_Context, file: file, function: function, line: line, string: logText)
}

public func DetailLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: Detail_Log_Context, file: file, function: function, line: line, string: logText)
}

public func DetailLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: Detail_Log_Context, file: file, function: function, line: line, string: logText)
}

public func DetailLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: Detail_Log_Context, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Nearby                  *
*                               *
*********************************/

public func NearbyLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: Nearby_Log_Context, file: file, function: function, line: line, string: logText)
}

public func NearbyLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: Nearby_Log_Context, file: file, function: function, line: line, string: logText)
}

public func NearbyLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: Nearby_Log_Context, file: file, function: function, line: line, string: logText)
}

public func NearbyLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: Nearby_Log_Context, file: file, function: function, line: line, string: logText)
}

public func NearbyLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: Nearby_Log_Context, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Featured                *
*                               *
*********************************/

public func FeaturedLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: Featured_Log_Context, file: file, function: function, line: line, string: logText)
}

public func FeaturedLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: Featured_Log_Context, file: file, function: function, line: line, string: logText)
}

public func FeaturedLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: Featured_Log_Context, file: file, function: function, line: line, string: logText)
}

public func FeaturedLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: Featured_Log_Context, file: file, function: function, line: line, string: logText)
}

public func FeaturedLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: Featured_Log_Context, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Root                    *
*                               *
*********************************/

public func RootLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: Root_Log_Context, file: file, function: function, line: line, string: logText)
}

public func RootLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: Root_Log_Context, file: file, function: function, line: line, string: logText)
}

public func RootLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: Root_Log_Context, file: file, function: function, line: line, string: logText)
}

public func RootLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: Root_Log_Context, file: file, function: function, line: line, string: logText)
}

public func RootLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: Root_Log_Context, file: file, function: function, line: line, string: logText)
}

/********************************
*                               *
*       Profile                 *
*                               *
*********************************/

public func ProfileLogDebug(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Debug, context: Profile_Log_Context, file: file, function: function, line: line, string: logText)
}

public func ProfileLogInfo(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Info, context: Profile_Log_Context, file: file, function: function, line: line, string: logText)
}

public func ProfileLogWarning(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Warning, context: Profile_Log_Context, file: file, function: function, line: line, string: logText)
}

public func ProfileLogVerbose(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Verbose, context: Profile_Log_Context, file: file, function: function, line: line, string: logText)
}

public func ProfileLogError(@autoclosure(escaping) logText: () -> String, level: DDLogLevel = defaultDebugLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: Profile_Log_Context, file: file, function: function, line: line, string: logText)
}

/// Analogous to the C preprocessor macro THIS_FILE
public func CurrentFileName(fileName: StaticString = __FILE__) -> String {
    // Using string interpolation to prevent integer overflow warning when using StaticString.stringValue
    return "\(fileName)".lastPathComponent.stringByDeletingPathExtension
}