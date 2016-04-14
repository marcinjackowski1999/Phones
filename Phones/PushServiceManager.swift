//
//  PushServiceManager.swift
//  Phones
//
//  Created by Marcin Jackowski on 14/04/16.
//  Copyright © 2016 Marcin Jackowski. All rights reserved.
//

import Foundation
import UIKit

class PushServiceManager {
    
    static let sharedInstance = PushServiceManager()
    private init() {}
    
    func registerForNotifications() {
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func getDeviceToken() -> String? {
        guard let deviceToken = NSUserDefaults.standardUserDefaults().valueForKey("kDeviceToken") as? NSData else { return nil }
        return deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
    func saveDeviceToken(deviceToken: NSData) {
        NSUserDefaults.standardUserDefaults().setValue(deviceToken, forKey: "kDeviceToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}