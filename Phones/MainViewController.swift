//
//  MainViewController.swift
//  Phones
//
//  Created by Marcin Jackowski on 11/12/15.
//  Copyright © 2015 Marcin Jackowski. All rights reserved.
//

import UIKit

class MainViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.viewController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func getBeaconsActionButton(sender: UIButton) {
        LocationManager.sharedInstance.getBeacons()
    }
}
