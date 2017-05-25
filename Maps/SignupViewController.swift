//
//  SignupViewController.swift
//  Maps
//
//  Created by Visal Sam on 20/04/2017.
//  Copyright © 2017 Visal Sam. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                displayAlertMessage(userMessage: "All fields are required")
                return
            }
        
        // Check for empty fields
        if(firstName.isEmpty || lastName.isEmpty || mail.isEmpty || phoneNumber.isEmpty || password.isEmpty) {
            // Display alert message
            displayAlertMessage(userMessage: "All fields are required")
            return
        }
        
        if(mail.characters.count <= 6) {
            // Display alert message
            displayAlertMessage(userMessage: "Mail invalid")
            return
        }
        
        if(phoneNumber.characters.count != 10) {
            // Display alert message
            displayAlertMessage(userMessage: "Phone number invalid")
            return
        }
        
        runSignup(firstname:firstName, lastname:lastName, mail:mail, user:phoneNumber, pass:password)

        // Send data to server
        
        // Add params and grab query
//        var url = URLComponents()
//        let firstNameQuery = URLQueryItem(name:"firstName", value:firstName)
//        let lastNameQuery = URLQueryItem(name:"lastName", value:lastName)
//        let mailQuery = URLQueryItem(name:"mail", value:mail)
//        let phoneNumberQuery = URLQueryItem(name:"phoneNumber", value:phoneNumber)
//        let passwordQuery = URLQueryItem(name:"password", value:password)
//        url.queryItems = [firstNameQuery, lastNameQuery, mailQuery, phoneNumberQuery, passwordQuery]
        
//        let toSend = url.query
//        request.httpBody = toSend?.data(using: String.Encoding.utf8)
//        
        }
    
    
    //Connection to server and serialize data into JSON
    func runSignup(firstname:String, lastname:String, mail:String, user:String, pass:String)
    {
        let login_url = URL(string: "52.232.34.116:8080/a/create")
        //let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: login_url!)
        request.httpMethod = "POST"
        
        let toSend = ["firstname": firstname, "lastname": lastname, "mail": mail, "user": user,"pass":pass]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: toSend, options: .prettyPrinted)
            print(NSString(data: request.httpBody!, encoding:String.Encoding.utf8.rawValue)!)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // Display an alert message
    func displayAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
    
        self.present(myAlert, animated: true, completion: nil)
    }
}
