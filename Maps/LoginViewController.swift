//
//  LoginViewController.swift
//  Maps
//
//  Created by Visal Sam on 20/04/2017.
//  Copyright © 2017 Visal Sam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        let preferences = UserDefaults.standard
        
        if(preferences.object(forKey: "session") != nil) {
            LogDone()
        }
        else {
            LoginToDo()
        }
    }
    
    @IBAction func sendLogin(_ sender: AnyObject) {
        let usernameToServ = phoneNumber.text
        let passwordToServ = password.text
        
        if(usernameToServ == "" || passwordToServ == ""){
            displayAlertMessage(userMessage: "All fields are required")
            return
        }
        
        runLog(user:usernameToServ!, pass:passwordToServ!)
    }
    
    // Connection to server
    func runLog(user:String, pass:String) {
        let login_url = URL(string: "52.232.34.116:8080/a/connect")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: login_url!)
        request.httpMethod = "POST"
        
        // Add params and grab query
//        var url = URLComponents()
//        let userQuery = URLQueryItem(name:"user", value:user)
//        let passQuery = URLQueryItem(name:"password", value:pass)
//        url.queryItems = [userQuery, passQuery]
        
//        let toSend = url.query
//        request.httpBody = toSend?.data(using: String.Encoding.utf8)

        let toSend = ["phone": user,"password":pass]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: toSend, options: .prettyPrinted)
            print(NSString(data: request.httpBody!, encoding:String.Encoding.utf8.rawValue)!)
        } catch let error {
            print(error.localizedDescription)
        }

       
        let task = session.dataTask(with:request as URLRequest, completionHandler:{ (data, response, error) in
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                return
            }
            
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch {
                return
            }
            
            guard let server_response = json as? NSDictionary else {
                return
            }
            
            if let data_block = server_response["data"] as? NSDictionary {
                if let session_data = data_block["session"] as? String {
                    let preferences = UserDefaults.standard
                    preferences.set(session_data, forKey: "session")
                    
                    DispatchQueue.main.async(execute: self.LogDone)
                }
            }
        })
        task.resume()
    }
    
    func LoginToDo() {
        phoneNumber.isEnabled = true
        password.isEnabled = true
    }
    
    func LogDone() {
        phoneNumber.isEnabled = false
        password.isEnabled = false
    }
    
    
    // Display an alert message
    func displayAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }
}
