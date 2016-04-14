//
//  LocationManager.swift
//  Phones
//
//  Created by Marcin Jackowski on 11/12/15.
//  Copyright © 2015 Marcin Jackowski. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    static let sharedInstance = LocationManager()
    private override init() {}
    
    weak var viewController: MainViewController?
    var localBeacons = [Beacon]()
    var locationManager = CLLocationManager()
    var lastMinBeacon: Beacon?

    func setup() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
        loadBeacons()
        startMonitoringBeacons()
    }
    
    
    func getBeacons() {
        stopMonitoringAllBeacons()
        
        BeaconsService.getBeacons { (result) in
            switch result {
            case .Success(let beacons):
                self.localBeacons = beacons!
                self.startMonitoringBeacons()
            case .Error:
                ()
            }
        }
    }
    
    func stopMonitoringAllBeacons() {
        loadBeacons()
        localBeacons.forEach { (beacon) -> () in
            stopMonitoringItem(beacon)
        }
    }
    
    func startMonitoringBeacons() {
        self.persistBeacons()
        self.localBeacons.forEach({ (beacon) -> () in
            self.startMonitoringItem(beacon)
        })
    }
    
    func persistBeacons() {
        var beaconsArray:[NSData] = []
        for beacon in localBeacons {
            let itemData = NSKeyedArchiver.archivedDataWithRootObject(beacon)
            beaconsArray.append(itemData)
        }
        NSUserDefaults.standardUserDefaults().setObject(beaconsArray, forKey: "beacons")
    }
    
    func loadBeacons() {
        if let storedBeacons = NSUserDefaults.standardUserDefaults().arrayForKey("beacons") {
            localBeacons = []
            
            for beacon in storedBeacons {
                let item = NSKeyedUnarchiver.unarchiveObjectWithData(beacon as! NSData) as! Beacon
                localBeacons.append(item)
            }
        }
    }
    
    func beaconRegionWithItem(beacon: Beacon) -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(proximityUUID: beacon.uuid, major: beacon.majorValue, minor: beacon.minorValue, identifier: beacon.name)
        return beaconRegion
    }
    
    func startMonitoringItem(beacon: Beacon) {
        let beaconRegion = beaconRegionWithItem(beacon)

        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        beaconRegion.notifyEntryStateOnDisplay = true
        
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
        locationManager.startUpdatingLocation()
    }
    
    func stopMonitoringItem(beacon: Beacon) {
        let beaconRegion = beaconRegionWithItem(beacon)
        locationManager.stopMonitoringForRegion(beaconRegion)
        locationManager.stopRangingBeaconsInRegion(beaconRegion)
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        if let beaconData = NSUserDefaults.standardUserDefaults().valueForKey("lastSeenBeacon") as? NSData {
            lastMinBeacon = NSKeyedUnarchiver.unarchiveObjectWithData(beaconData) as? Beacon
        }
        
        if(beacons.count > 0) {
            
            if let lastMinBeacon = lastMinBeacon {
                for beacon in beacons {
                    
                    loadBeacons()
                    
                    for localBeacon in localBeacons {
                        
                        if localBeacon == beacon {
                            
                            localBeacon.lastSeenBeacon = beacon
                            if lastMinBeacon != localBeacon {
                                switch beacon.proximity {
                                case .Near, .Far, .Immediate:
                                    if localBeacon.lastSeenBeacon?.accuracy > 0 {
                                        if lastMinBeacon.lastSeenBeacon?.accuracy > localBeacon.lastSeenBeacon?.accuracy {
                                            self.lastMinBeacon = localBeacon
                                            self.lastMinBeacon?.lastSeenBeacon = beacon
                                        }
                                    }
                                case .Unknown:
                                    ()
                                }
                            } else {
                                self.lastMinBeacon = localBeacon
                            }
                        }
                    }
                }
                
                let itemData = NSKeyedArchiver.archivedDataWithRootObject(self.lastMinBeacon!)
                NSUserDefaults.standardUserDefaults().setObject(itemData, forKey: "lastSeenBeacon")
                sendLocation()
            } else {
                if let i = localBeacons.indexOf({$0 == beacons[0]}) {
                    if beacons[0].accuracy > 0 {
                        lastMinBeacon = localBeacons[i]
                        lastMinBeacon?.lastSeenBeacon = beacons[0]
                    }
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LocationManager.sharedInstance.setup()
        manager.stopUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        LocationManager.sharedInstance.setup()
        manager.stopUpdatingLocation()
        manager.stopMonitoringForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        LocationManager.sharedInstance.setup()
        manager.stopUpdatingLocation()
        manager.stopMonitoringForRegion(region)
    }

    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
//         if (state == .Inside) {
//            sendLocalNotificationWithMessage("Inside")
//            LocationManager.sharedInstance.setup()
//            manager.startMonitoringForRegion(region)
//         } else {
//            sendLocalNotificationWithMessage("Outside")
//            LocationManager.sharedInstance.setup()
//            manager.startMonitoringForRegion(region)
//        }
    }
    
    func sendLocation() {
        let userDefaults = NSUserDefaults.standardUserDefaults()

        guard let databaseId = userDefaults.valueForKey("databaseId") as? String, beacon = NSKeyedUnarchiver.unarchiveObjectWithData(userDefaults.valueForKey("lastSeenBeacon") as! NSData) as? Beacon else {
            return
        }
        
        let parameters = SendLocationService.Parameters(majorValue: Int(beacon.majorValue), minorValue: Int(beacon.minorValue))
        SendLocationService().sendLocation(databaseId, parameters: parameters) { (result) -> Void in
            switch result {
            case .Success(_):
                ()
            case .Error():
                ()
            }
        }
    }
}