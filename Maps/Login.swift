//
//  Login.swift
//  Maps
//
//  Created by Visal Sam on 20/04/2017.
//  Copyright © 2017 Visal Sam. All rights reserved.
//

import UIKit

class Login: UIViewController {
 
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var mdp: UITextField!
    @IBOutlet weak var logButton: UIButton!
    
    override func viewDidLoad() {
       
        let preferences = UserDefaults.standard
        
        if(preferences.object(forKey: "session") != nil)
        {
            LogDone()
        }
        else{
            LoginToDo()
        }
    }
    
    @IBAction func sendLogIn(_ sender: Any) {
        
        let usernameToServ = phoneNumber.text
        let passwordToServ = mdp.text
        
        if(usernameToServ == "" || passwordToServ == ""){
            return
        }
        
        runLog(user:usernameToServ!, pass:passwordToServ!)
    }
    
    //fonction permettant de se co à une url
    func runLog(user:String, pass:String)
    {
        let login_url = URL(string: "localhost")
        let session = URLSession.shared
    
        let request = NSMutableURLRequest(url: login_url!)
        request.httpMethod = "POST"
        
        let toSend = "username=" + user + "&password=" + pass
        request.httpBody = toSend.data(using: String.Encoding.utf8)

        let task = session.dataTask(with:request as URLRequest, completionHandler:{ (data, response, error) in
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            let json: Any?
            do
            {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch
            {
                return
            }
            
            guard let server_response = json as? NSDictionary else
            {
                return
            }
            
            if let data_block = server_response["data"] as? NSDictionary
            {
                if let session_data = data_block["session"] as? String
                {
                    let preferences = UserDefaults.standard
                    preferences.set(session_data, forKey: "session")
                    
                    DispatchQueue.main.async(execute: self.LogDone)
                }
            }
        })
        task.resume()
    }
    
    func LoginToDo(){
        phoneNumber.isEnabled = true
        mdp.isEnabled = true
    }
    
    
    func LogDone(){
        phoneNumber.isEnabled = false
        mdp.isEnabled = false
    }
    
    
}
