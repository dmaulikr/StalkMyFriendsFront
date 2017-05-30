//
//  MeViewController.swift
//  Maps
//
//  Created by Visal Sam on 20/04/2017.
//  Copyright © 2017 Visal Sam. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {
    
     var defaults = UserDefaults.standard
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(defaults.string(forKey: "token") != nil) {
            firstNameLabel.text = defaults.string(forKey: "firstName")
            lastNameLabel.text = defaults.string(forKey: "lastName")
            phoneNumberLabel.text = defaults.string(forKey: "phoneNumber")
        }
    }
    
    @IBAction func logOutAction(_ sender: AnyObject) {
        if defaults.string(forKey: "token") != nil {
            defaults.removeObject(forKey: "firstName")
            defaults.removeObject(forKey: "lastName")
            defaults.removeObject(forKey: "phoneNumber")
            defaults.removeObject(forKey: "token")
            defaults.synchronize()
            
            let loginViewController = (self.storyboard?.instantiateViewController(withIdentifier: "tabBarController"))! as UIViewController
            self.navigationController?.pushViewController(loginViewController, animated: false)
        }
    }
}
