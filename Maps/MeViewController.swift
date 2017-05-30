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
        guard let url = URL(string: "http://52.232.34.116:8080/api/user/logout") else {
            return
        }
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let phoneNumberToSend = defaults.string(forKey: "phoneNumber")! as String
        
        let toSend = ["phoneNumber": phoneNumberToSend]
        
        print(toSend)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: toSend, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            let task = session.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    self.displayAlertMessage(title: "Error server", userMessage: "Error from server")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    self.displayAlertMessage(title: "Error server", userMessage: "Error from server")
                    return
                }
                
                if self.defaults.string(forKey: "token") != nil {
                    self.defaults.removeObject(forKey: "firstName")
                    self.defaults.removeObject(forKey: "lastName")
                    self.defaults.removeObject(forKey: "phoneNumber")
                    self.defaults.removeObject(forKey: "token")
                    self.defaults.removeObject(forKey: "isConnected")
                    self.defaults.synchronize()
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "logout", sender: self)
                }
            }
            task.resume()
        }
    }
    
    // Display an alert message
    func displayAlertMessage(title: String, userMessage: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
