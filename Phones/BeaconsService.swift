//
//  BeaconService.swift
//  Phones
//
//  Created by Marcin Jackowski on 29/01/16.
//  Copyright © 2016 Marcin Jackowski. All rights reserved.
//

import Foundation
import Alamofire

class BeaconsService {

    class func getBeacons(completion: (Result<[Beacon]>) -> Void) {
        Alamofire.request(Router.GetBeacons()).validate().responseJSON { request, response, result in
            switch result {
            case .Success(let value):
                
                let beacons = BeaconSerializer.getBeaconsList(value as? Array<[String: AnyObject]>)
                completion(.Success(beacons))
                
            case .Failure(let data, let error):
                completion(.Error)
            }
        }
    }
}