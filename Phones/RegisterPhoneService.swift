//
//  Location.swift
//  Phones
//
//  Created by Marcin Jackowski on 11/12/15.
//  Copyright © 2015 Marcin Jackowski. All rights reserved.
//

import Foundation
import Alamofire

class RegisterPhoneService {
    
    struct Parameters {
                
        let name: String
        let phoneId: String

        var dictionaryRepresentation: [String: AnyObject]? {
            var dict: [String: AnyObject] = [:]

            dict["name"] = name
            dict["phoneId"] = phoneId
            dict["deviceToken"] = PushServiceManager.sharedInstance.getDeviceToken()
            dict["currentBeacon"] = ["majorValue": 0, "minorValue": 0]
            dict["lastBeacon"] = ["majorValue": 0, "minorValue": 0]

            return dict
        }
    }
    
    func register(parameters: Parameters, completion: (Result<String>) -> Void) {
        Alamofire.request(Router.RegisterPhone(parameters.dictionaryRepresentation)).validate().responseJSON { request, response, result in
            switch result {
            case .Success(let value):
                guard let responseData = value as? [String: AnyObject], let databaseId = responseData["_id"] as? String else {
                    completion(.Error)
                    return
                }
                
                completion(.Success(databaseId))
            case .Failure(let data, let error):
                completion(.Error)
            }
        }
    }
}