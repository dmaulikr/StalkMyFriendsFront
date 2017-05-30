//
//  AddContactViewController.swift
//  Maps
//
//  Created by Visal Sam on 30/05/17.
//  Copyright © 2017 Visal Sam. All rights reserved.
//


import Foundation
import UIKit

class AddContactViewController: UIViewController {
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var phoneNumberFriend: UITextField!
    
    @IBAction func actionAddContact(_ sender: Any) {
        guard let phoneNumberFriend = phoneNumberFriend.text else {
            return
        }
        
        if(phoneNumberFriend == "") {
            displayAlertMessage(title: "Empty fields", userMessage: "Field is required")
            return
        }
        
        if(phoneNumberFriend.characters.count != 10) {
            displayAlertMessage(title: "Invalid value", userMessage: "Phone number invalid")
            return
        }
        
        guard let url = URL(string: "http://52.232.34.116:8080/api/friends/add") else {
            return
        }
        
        let phoneNumber = defaults.string(forKey: "phoneNumber")! as String
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let toSend = ["phoneNumber": phoneNumber, "phoneNumberFriend": phoneNumberFriend]
        
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
                    self.displayAlertMessage(title: "No existing account", userMessage: "The requested number is not valid")
                    return
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "addContactToList", sender: self)
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
