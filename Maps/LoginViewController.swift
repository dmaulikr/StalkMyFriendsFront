//
//  LoginViewController.swift
//  Maps
//
//  Created by Visal Sam on 20/04/2017.
//  Copyright © 2017 Visal Sam. All rights reserved.
//

import UIKit
import GoogleMobileAds

class LoginViewController: UIViewController, GADInterstitialDelegate {
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = createAndLoadInterstitial()
        
        let preferences = UserDefaults.standard
        
        if(preferences.object(forKey: "session") != nil) {
            LogDone()
        }
        else {
            LoginToDo()
        }
    }
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        // Remove the following line before you upload the app
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
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
        guard let url = NSURL(string: "http://52.232.34.116:8080/api/user/connect") else {
            print("Error url")
            return
        }
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add params and grab query
        let toSend = ["phoneNumber": user,"password":pass]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: toSend, options: .prettyPrinted)
            print(NSString(data: request.httpBody!, encoding:String.Encoding.utf8.rawValue)!)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    print("\n\n\n\n\(responseJSON)")
                }
            } catch let error {
                print(error.localizedDescription)
            }
            //            if let data_block = server_response["data"] as? NSDictionary {
            //                if let session_data = data_block["session"] as? String {
            //                    let preferences = UserDefaults.standard
            //                    preferences.set(session_data, forKey: "session")
            //
            //                    DispatchQueue.main.async(execute: self.LogDone)
            //                }
            //            }
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
