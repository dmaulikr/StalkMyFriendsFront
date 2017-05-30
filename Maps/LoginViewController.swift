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
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (defaults.string(forKey: "token") != nil && defaults.bool(forKey: "isConnected")) {
            let TabBarControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
            self.navigationController?.pushViewController(TabBarControllerObj!, animated: false)
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
        guard let phoneNumberToSend = phoneNumber.text, let passwordToSend = password.text else {
            return
        }
        
        if(phoneNumberToSend == "" || passwordToSend == "") {
            displayAlertMessage(title: "Empty fields", userMessage: "All fields are required")
            return
        }
        
        if(phoneNumberToSend.characters.count != 10) {
            displayAlertMessage(title: "Invalid value", userMessage: "Phone number invalid")
            return
        }
        
        guard let url = URL(string: "http://52.232.34.116:8080/api/user/connect") else {
            return
        }
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let toSend = ["phoneNumber": phoneNumberToSend, "password":passwordToSend]
        
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
                    self.displayAlertMessage(title: "No account", userMessage: "Wrong phone number or password")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let responseJSON = json {
                        self.defaults.set(responseJSON["firstName"], forKey: "firstName")
                        self.defaults.set(responseJSON["lastName"], forKey: "lastName")
                        self.defaults.set(responseJSON["phoneNumber"], forKey: "phoneNumber")
                        self.defaults.set(responseJSON["token"], forKey: "token")
                        self.defaults.set(true, forKey: "isConnected")
                        self.defaults.synchronize()
                    }
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loginToMap", sender: self)
                    }
                        
                    self.interstitial = self.createAndLoadInterstitial()
                }
                catch let error {
                    print(error.localizedDescription)
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
