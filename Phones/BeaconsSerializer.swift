//
//  BeaconsSerializer.swift
//  Phones
//
//  Created by Marcin Jackowski on 29/01/16.
//  Copyright © 2016 Marcin Jackowski. All rights reserved.
//

import Foundation

class BeaconSerializer {
    
    class func getBeaconsList(responseData: Array<[String: AnyObject]>?) -> [Beacon] {
        var beacons: [Beacon] = []
        
        guard let responseData = responseData else {
            return beacons
        }
        
        for beacon in responseData {
            guard let uuid = beacon["uuid"] as? String,
                name = beacon["name"] as? String,
                majorValue = beacon["majorValue"] as? Int,
                minorValue = beacon["minorValue"] as? Int else {
                
                    return []
            }
            
            let tempBeacon = Beacon(name: name, uuid: NSUUID(UUIDString: uuid)!, majorValue: UInt16(majorValue), minorValue: UInt16(minorValue))
            beacons.append(tempBeacon)
        }
        
        return beacons
    }
}