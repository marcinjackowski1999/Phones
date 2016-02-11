//
//  Beacon.swift
//  Phones
//
//  Created by Marcin Jackowski on 21/01/16.
//  Copyright © 2016 Marcin Jackowski. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct BeaconConstant {
    static let nameKey = "name"
    static let uuidKey = "uuid"
    static let majorKey = "major"
    static let minorKey = "minor"
    static let lastSeenBeaconKey = "lastSeenBeacon"
}

class Beacon: NSObject, NSCoding {
    let name: String
    let uuid: NSUUID
    let majorValue: CLBeaconMajorValue
    let minorValue: CLBeaconMinorValue
    dynamic var lastSeenBeacon: CLBeacon?
    
    init(name: String, uuid: NSUUID, majorValue: CLBeaconMajorValue, minorValue: CLBeaconMinorValue) {
        self.name = name
        self.uuid = uuid
        self.majorValue = majorValue
        self.minorValue = minorValue
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(BeaconConstant.nameKey) as! String
        uuid = aDecoder.decodeObjectForKey(BeaconConstant.uuidKey) as! NSUUID
        majorValue = UInt16(aDecoder.decodeIntegerForKey(BeaconConstant.majorKey))
        minorValue = UInt16(aDecoder.decodeIntegerForKey(BeaconConstant.minorKey))
        if let lastSeenBeacon = aDecoder.decodeObjectForKey(BeaconConstant.lastSeenBeaconKey) as? CLBeacon {
            self.lastSeenBeacon = lastSeenBeacon
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: BeaconConstant.nameKey)
        aCoder.encodeObject(uuid, forKey: BeaconConstant.uuidKey)
        aCoder.encodeInteger(Int(majorValue), forKey: BeaconConstant.majorKey)
        aCoder.encodeInteger(Int(minorValue), forKey: BeaconConstant.minorKey)
        aCoder.encodeObject(lastSeenBeacon, forKey: BeaconConstant.lastSeenBeaconKey)
    }
}

func ==(beacon: Beacon, toCompareBeacon: CLBeacon) -> Bool {
    return ((toCompareBeacon.proximityUUID.UUIDString == beacon.uuid.UUIDString)
        && (Int(toCompareBeacon.major) == Int(beacon.majorValue))
        && (Int(toCompareBeacon.minor) == Int(beacon.minorValue)))
}

func !=(beacon: Beacon, toCompareBeacon: Beacon) -> Bool {
    return ((toCompareBeacon.uuid.UUIDString == beacon.uuid.UUIDString)
        && (Int(toCompareBeacon.majorValue) != Int(beacon.majorValue))
        && (Int(toCompareBeacon.minorValue) != Int(beacon.minorValue)))
}