//
//  Router.swift
//  Router
//
//  Created by Marcin Jackowski on 01/07/15.
//  Copyright (c) 2015 Marcin Jackowski. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T> {
    case Success(T?)
    case Error
}

enum Router: URLRequestConvertible {
    static let baseURLString = "http://192.168.1.19:3000/"
    
    var method: Alamofire.Method {
        switch self {
        case .RegisterPhone:
            return .POST
        case .SendLocation:
            return .PUT
        default:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .RegisterPhone:
            return "phones"
        case .SendLocation(let databaseId, _):
            return "phones/" + databaseId
        case .GetBeacons:
            return "beacons"
        }
    }
    
    case RegisterPhone([String: AnyObject]?)
    case GetBeacons()
    case SendLocation(String, [String: AnyObject]?)
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .RegisterPhone(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .SendLocation(_, let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .GetBeacons():
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: nil).0
        }
    }
}