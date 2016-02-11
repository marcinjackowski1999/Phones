//
//  BackgroundManager.swift
//  Phones
//
//  Created by Marcin Jackowski on 02/02/16.
//  Copyright © 2016 Marcin Jackowski. All rights reserved.
//

import Foundation
import UIKit

class bgManager:NSObject{
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    override init(){
        super.init()
    }
    func registerBackgroundTask() {
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            [unowned self] in
            self.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
}