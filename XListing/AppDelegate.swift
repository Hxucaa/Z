//
//  AppDelegate.swift
//  XListing
//
//  Created by Lance on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

@UIApplicationMain
public final class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    private var appDependencies: AppDependencies!
    private let backgroundOperationsWorkerFactory: IBackgroundOperationsWorkerFactory = BackgroundOperationsWorkerFactory()
    
    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // configure CocoaLumberjack
        Logger.configure()
        
        // connect to LeanCloud
        LeanCloudClient.initialize()
        if let launchOptions = launchOptions {
            LeanCloudClient.trackAppOpenedWithLaunchOptions(launchOptions)
        }
        
        // start background workers
        backgroundOperationsWorkerFactory.startWorkers()
                
        // start dependency injector
        appDependencies = AppDependencies(window: window!)
        
        // initialize root view
        appDependencies.installRootViewControllerIntoWindow()
        
        // draw colored status bar
        var view: UIView = UIView(frame:CGRectMake(0, 0,self.window!.rootViewController!.view.bounds.width, 20))
        view.backgroundColor = UIColor(red: 50/255, green: 173/255, blue: 155/255, alpha: 1)
        self.window?.rootViewController?.view.addSubview(view)
        
        return true
    }
    
    public func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    public func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    public func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    public func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    public func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // set first launch status
        if (!NSUserDefaults.standardUserDefaults().boolForKey("NotFirstLaunch")) {
            BOLogInfo("First launch complete")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "NotFirstLaunch")
        }
    }
}

