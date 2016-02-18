//
//  Config.swift
//  XListing
//
//  Created by Hong Zhu on 2016-02-05.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import SDWebImage
import AVOSCloud
import CocoaLumberjack

public final class Config {
    
    public static func trackAppOpenedWithLaunchOptions(launchOptions: [NSObject : AnyObject]) {
        
        AVAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    }
    
    public class func config() {
        
        loadKeys()
        configureCocoaLumberjack()
        configureSDWebImage()
        configureLeanCloud()
    }
    
    private class func configureSDWebImage() {
        // FIXME: temporary until this is resolved: https://github.com/facebook/AsyncDisplayKit/issues/955
        SDImageCache.sharedImageCache().shouldDecompressImages = false
        SDWebImageDownloader.sharedDownloader().shouldDecompressImages = false
    }
    
    private class func configureLeanCloud() {
        
        AVOSCloud.setLastModifyEnabled(true)
        AVOSCloud.setVerbosePolicy(kAVVerboseAuto)
        
        AVAnalytics.setAnalyticsEnabled(true)
        #if DEBUG
            AVAnalytics.setLogEnabled(true)
        #endif
        
        
        //        User.enableAutomaticUser()
        
        User.registerSubclass()
        Me.registerSubclass()
        User_Business_Participation.registerSubclass()
        Address.registerSubclass()
        Business.registerSubclass()
    }
    
    private static func loadKeys() {
        var id: String?
        var key: String?
        
        let env = NSProcessInfo.processInfo().environment
        if let mode = env["exec_mode"] as String! {
            LSLogInfo("We are in \(mode.uppercaseString) mode!")
            
            let path = NSBundle.mainBundle().pathForResource("Parse", ofType: "plist")
            let dict: AnyObject = NSDictionary(contentsOfFile: path!)!
            
            if let modeDict: AnyObject = dict.objectForKey(mode) {
                id = modeDict.objectForKey("id") as? String
                key = modeDict.objectForKey("key") as? String
            }
            
        } else {
            
        }
        
        let errorMessage = "Unable to find Parse id and key for initialization"
        if let _id: String = id {
            if let _key: String = key {
                AVOSCloud.setApplicationId(_id, clientKey: _key)
            }
            else {
                LSLogError(errorMessage)
            }
        }
        else {
            LSLogError(errorMessage)
        }
    }
    
    
    private class func configureCocoaLumberjack() {
        let consoleFormatter = ConsoleFormatter()
        let aslFormatter = ASLFormatter()
        
        configConsoleLogger(consoleFormatter)
        configAppleSystemLogger(aslFormatter)
    }
    
    private class func configConsoleLogger(formatter: ConsoleFormatter? = nil) {
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
    
    private class func configAppleSystemLogger(formatter: ASLFormatter? = nil) {
        let logger = DDASLLogger.sharedInstance()
        if let formatter = formatter {
            logger.logFormatter = formatter
        }
        
        DDLog.addLogger(logger, withLevel: DDLogLevel.Info)
    }
    
    private class func configFileLogger(formatter: ConsoleFormatter? = nil) {
        
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        if let formatter = formatter {
            fileLogger.logFormatter = formatter
        }
        
        DDLog.addLogger(fileLogger, withLevel: DDLogLevel.Info)
    }
}