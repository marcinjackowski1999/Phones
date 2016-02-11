//
//  SendLocationService.swift
//  Phones
//
//  Created by Marcin Jackowski on 29/01/16.
//  Copyright © 2016 Marcin Jackowski. All rights reserved.
//

import Foundation
import Alamofire

class SendLocationService {
    
    struct Parameters {
        
        let majorValue: Int
        let minorValue: Int
        
        var dictionaryRepresentation: [String: AnyObject]? {
            var dict: [String: AnyObject] = [:]

            dict["currentBeacon"] = ["majorValue": majorValue, "minorValue": minorValue]
            
            return dict
        }
    }
    
    func sendLocation(databaseId: String, parameters: Parameters, completion: (Result<String?>) -> Void) {
        Alamofire.request(Router.SendLocation(databaseId, parameters.dictionaryRepresentation)).validate().responseJSON { request, response, result in
            switch result {
            case .Success(let value):
                completion(.Success(nil))
            case .Failure(let data, let error):
                completion(.Error)
            }
        }
    }
}