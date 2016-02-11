//
//  ViewController.swift
//  Phones
//
//  Created by Marcin Jackowski on 11/12/15.
//  Copyright © 2015 Marcin Jackowski. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    func setRootViewController(viewController: UIViewController) {
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
    }
}