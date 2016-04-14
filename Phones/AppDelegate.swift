//
//  AppDelegate.swift
//  Phones
//
//  Created by Marcin Jackowski on 11/12/15.
//  Copyright © 2015 Marcin Jackowski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            
            var viewController: ViewController?
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if let _ = userDefaults.valueForKey("databaseId") {
                viewController = MainViewController()
            } else {
                viewController = SetupPhoneViewController()
            }

            LocationManager.sharedInstance.setup()
            PushServiceManager.sharedInstance.registerForNotifications()

            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
        
        return true
    }
    

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        PushServiceManager.sharedInstance.saveDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        LocationManager.sharedInstance.setup()
        LocationManager.sharedInstance.startMonitoringBeacons()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
                
        LocationManager.sharedInstance.setup()
        LocationManager.sharedInstance.startMonitoringBeacons()
        
        let bgTask = bgManager()
        bgTask.registerBackgroundTask()
        LocationManager.sharedInstance.setup()
        LocationManager.sharedInstance.startMonitoringBeacons()
        
        let delayInSeconds = 8.0
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            bgTask.endBackgroundTask()
            completionHandler(UIBackgroundFetchResult.NewData)
        } 
    }
    
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
}

