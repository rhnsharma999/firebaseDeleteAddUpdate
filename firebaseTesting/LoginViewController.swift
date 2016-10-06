//
//  LoginViewController.swift
//  firebaseTesting
//
//  Created by Rohan Lokesh Sharma on 06/10/16.
//  Copyright © 2016 rohan. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {

  
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passField: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signIn(_ sender: AnyObject) {
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passField.text!) { (user, error) in
            // ...
            
            print("////////////")
            print(error)
            print("////////////") 
            
            
        }
        
        
        
    }

    @IBAction func createAcc(_ sender: AnyObject) {
        
        FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passField.text!) { (user, error) in
            // ...
        }
        
        
    }
}
