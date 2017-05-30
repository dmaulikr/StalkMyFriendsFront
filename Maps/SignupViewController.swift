//
//  SignupViewController.swift
//  Maps
//
//  Created by Visal Sam on 20/04/2017.
//  Copyright © 2017 Visal Sam. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SignupViewController: UIViewController, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Action when clicking on Sign up button
    @IBAction func signupButton(_ sender: AnyObject) {
        guard let firstName = firstNameText.text,
            let lastName = lastNameText.text,
            let mail = mailText.text,
            let phoneNumber = phoneNumberText.text,
            let password = passwordText.text else {
                return
            }
        
        // Check for empty fields
        if(firstName.isEmpty || lastName.isEmpty || mail.isEmpty || phoneNumber.isEmpty || password.isEmpty) {
            displayAlertMessage(title: "Empty fields", userMessage: "All fields are required")
            return
        }
        
        if(mail.characters.count <= 6) {
            displayAlertMessage(title: "Mail invalid", userMessage: "Mail has to be at least 6 characters")
            return
        }
        
        if(phoneNumber.characters.count != 10) {
            displayAlertMessage(title: "Phone number invalid", userMessage: "Phone number has to be 10 characters")
            return
        }
        
        guard let url = NSURL(string: "http://52.232.34.116:8080/api/user/create") else {
            return
        }
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let toSend = ["firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "email": mail, "password": password]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: toSend, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil{
                    self.displayAlertMessage(title: "Error server", userMessage: "Error from server")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    self.displayAlertMessage(title: "Account exists", userMessage: "An account linked to this phone number already exists")
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
                        self.performSegue(withIdentifier: "signupToMap", sender: self)
                    }
                    usleep(4000000)
                    self.interstitial = self.createAndLoadInterstitial()
                } catch let error {
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
