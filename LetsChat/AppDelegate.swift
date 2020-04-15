//
//  AppDelegate.swift
//  LetsChat
//
//  Created by Navjot Singh on 1/13/20.
//  Copyright © 2020 Navjot Singh. All rights reserved.
//

import UIKit
import CocoaLumberjack

var dateFormatter = DateFormatter()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        DDLog.add(DDTTYLogger.sharedInstance, with: DDLogLevel.all)
        
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        xmppManager.sharedInstance.xmppController.disconnect()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if xmppManager.sharedInstance.xmppController != nil {
            xmppManager.sharedInstance.xmppController.connect()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}
