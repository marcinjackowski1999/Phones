//
//  SetupPhoneViewController.swift
//  Phones
//
//  Created by Marcin Jackowski on 11/12/15.
//  Copyright © 2015 Marcin Jackowski. All rights reserved.
//

import UIKit

class SetupPhoneViewController: ViewController {

    @IBOutlet weak var phoneNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerPhoneButtonAction(sender: UIButton) {
        guard let phoneName = phoneNameTextField.text, deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString where !phoneName.isEmpty else {
            return
        }
                
        let parameters = RegisterPhoneService.Parameters(name: phoneName, phoneId: deviceId)
        RegisterPhoneService().register(parameters) { (result) -> Void in
            switch result {
            case .Success(let databaseId):
                NSUserDefaults.standardUserDefaults().setValue(databaseId, forKey: "databaseId")
                let mainViewController = MainViewController()
                self.setRootViewController(mainViewController)
            case .Error:
                ()
            }
        }
    }
}
