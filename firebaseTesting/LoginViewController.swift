//
//  LoginViewController.swift
//  firebaseTesting
//
//  Created by Rohan Lokesh Sharma on 06/10/16.
//  Copyright © 2016 rohan. All rights reserved.
//

import UIKit
import Firebase
import Material
import GSMessages
import SystemConfiguration






class LoginViewController: UIViewController,UITextFieldDelegate {

    var toSend = "unknown"
    @IBOutlet var cardView: UIView!
    @IBOutlet var signInButton:RaisedButton!
    @IBOutlet var createAccBUtton:RaisedButton!
    @IBOutlet var signInActivity:UIActivityIndicatorView!
    @IBOutlet var createAccActivity:UIActivityIndicatorView!
   
    
    @IBOutlet var emailField:TextField!
    @IBOutlet var passField:TextField!

    
    @IBOutlet var testing: RaisedButton!
  //  let emailField = TextField()
  //  let passField = TextField()

    override func viewDidLayoutSubviews() {
      
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        signInActivity.isHidden = true
        createAccActivity.isHidden = true
        createAccBUtton.title = "Create Account"
        signInButton.title = "Sign In"
    }
    
    override func viewDidLoad() {
        
        FIRDatabase.database().persistenceEnabled = true
        
        self.checkSignedIn()
        
        signInActivity.isHidden = true
        createAccActivity.isHidden = true
    
       
   
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        
        self.emailField.delegate = self;
        self.passField.delegate = self;
        
       
    
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //layout stuffies, handle with care or the UI looks bad
        
        
   
      

        emailField.placeholder = "Email"
      //  cardView.layout(emailField).top(40).horizontally(left: 30, right: 30)
        passField.placeholder = "Password"
        passField.isVisibilityIconButtonEnabled = true
        
     //   cardView.layout(passField).top(110).horizontally(left: 30, right: 30)
     
        
      //  cardView.layout(createAccBUtton).top(240).horizontally(left: 30, right: 30)
        
        signInButton.pulseColor = .white
        createAccBUtton.pulseColor = .white
        emailField.autocorrectionType = .no
        emailField.keyboardType = .URL
        emailField.autocapitalizationType = .none
        let color1 = UIColor(rgb: UInt(Reusable.blue_white_color_gardient1)).cgColor
        
        let color2 = UIColor(rgb: UInt(Reusable.blue_white_color_gradient2)).cgColor
        
        let gradient = CAGradientLayer()
        let gradient1 = CAGradientLayer()
        gradient.frame = signInButton.bounds
        gradient1.frame = createAccBUtton.bounds
        gradient1.colors = [color1,color2];

       
        gradient.colors = [color1,color2];
        
        gradient.locations = [0.0,1.0]
        signInButton.layer.insertSublayer(gradient, at: 0)
        createAccBUtton.layer.insertSublayer(gradient1, at: 0)
        
        signInButton.backgroundColor = UIColor.clear
        createAccBUtton.backgroundColor = .clear
      
        
        
        
        
        //layout stuffies, handle with care or the UI looks bad
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        super.viewDidLoad()
    
        

        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
     
        
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
    
        return true
        
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailField.detail = ""
        passField.detail = ""
        emailField.detailColor = .white
        passField.detailColor = .white
        
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "login")
        {
            let vc = segue.destination as! ViewController
            vc.user = self.toSend
            
            
        }
    }
  
    
    @IBAction func signIn(_ sender: AnyObject) {
        
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
        
        if(emailField.text?.characters.count == 0 || passField.text?.characters.count == 0 )
        {
            if(emailField.text?.characters.count == 0)
            {
                emailField.detailColor = .red
                emailField.detail = "Field Can't be left blank"
            }
            if(passField.text?.characters.count == 0)
            {
                passField.detailColor = .red
                passField.detail = "Field Can't be left blank"
                
            }
            
        }
        else if(!connectedToNetwork())
        {
            self.showAlert(title: "Error", msg: "No Internet", error: true)
            
        }
        else
        {
            
            signInButton.title = ""
            signInActivity.isHidden = false
            signInActivity.startAnimating()
            FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passField.text!) { (user, error) in
               
                
                if(error != nil)
                {
                    self.showAlert(title: "Error", msg: (error?.localizedDescription)!, error: true)
                    
                }
                else{
                    
                 
                    if let some = user?.email
                    {
                        
                        self.toSend = some
                    }
                    self.performSegue(withIdentifier: "login", sender: self)

                    
                }
                
                
            }
        }
        
        
        
        
        
    }

    @IBAction func createAcc(_ sender: AnyObject) {
        
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
        
        if(emailField.text?.characters.count == 0 || passField.text?.characters.count == 0 )
        {
            if(emailField.text?.characters.count == 0)
            {
                emailField.detailColor = .red
                emailField.detail = "Field Can't be left blank"
            }
            if(passField.text?.characters.count == 0)
            {
                passField.detailColor = .red
                passField.detail = "Field Can't be left blank"
                
            }
            
        }
            
        else if(!connectedToNetwork())
        {
            self.showAlert(title: "Error", msg: "No Internet", error: true)
            
        }
        else
        {
            
            createAccBUtton.title = ""
            createAccActivity.isHidden = false
            createAccActivity.startAnimating()
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passField.text!) { (user, error) in
            
                
                if(error != nil)
                {
                 self.showAlert(title: "Error", msg: (error?.localizedDescription)!, error: true)
               
                }
                else
                {
                    self.showAlert(title: "Success", msg: "Account Was Created Successfully", error: false)
                    print("lol")
              
                }
                
            }
        }
       
        
        
    }
    
    func showAlert(title:String, msg:String, error:Bool)
    {
        
        signInActivity.isHidden = true
        createAccActivity.isHidden = true
        createAccBUtton.title = "Create Account"
        signInButton.title = "Sign In"
        
    
        if(error)
        {
            
            self.showMessage(msg, type: .error, options: [
                .animation(.slide),
                .animationDuration(0.3),
                .autoHide(true),
                .autoHideDelay(3.0),
                .height(44.0),
                .hideOnTap(true),
                .position(.top),
                .textAlignment(.center),
                .textColor(UIColor.white),
                .textNumberOfLines(0),
                .textPadding(30.0),
                
                ])
         
        }
        else
        {
           
            self.showMessage(msg, type: .success, options: [
                .animation(.slide),
                .animationDuration(0.3),
                .autoHide(true),
                .autoHideDelay(3.0),
                .height(44.0),
                .hideOnTap(true),
                .position(.top),
                .textAlignment(.center),
                .textColor(UIColor.white),
                .textNumberOfLines(0),
                .textPadding(30.0)
                ])
            
        }
    }
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    func checkSignedIn()
    {
        if let user = FIRAuth.auth()?.currentUser {
            
            self.toSend = (user.email)!
            
            
            self.performSegue(withIdentifier: "login", sender: self)
            
            
            // User is signed in.
        } else {
            // No user is signed in.
        }
    }
}



