//
//  ViewController.swift
//  firebaseTesting
//
//  Created by Rohan Lokesh Sharma on 05/10/16.
//  Copyright © 2016 rohan. All rights reserved.
//

import UIKit
import Material
import Firebase
import GSMessages
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    var rows:Int!
    
    var user:String!
    
    
    @IBOutlet var sendMessageView:UIView!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var messageField: UITextField!
    @IBOutlet var myTableView:UITableView!
    
    var field:UITextField!
    var point:CGFloat!
    var point1:CGFloat!
    @IBOutlet var rowField: UITextField!
    
    var decide = false

    var origTable:CGFloat!
    var chotaTable:CGFloat!
    
    
    var initialFrame:CGRect!
   
    @IBOutlet var updateNameField: UITextField!
    @IBOutlet var updateMessageField: UITextField!
    var messages = [FIRDataSnapshot]()
    var ref:FIRDatabaseReference!
    var ref_handle:FIRDatabaseHandle!
    
    
    
    

    override func viewDidLoad() {
        
        
        
        checkConnectionState()
        origTable = self.myTableView.bounds.height
        
        
        print(user)
      
        self.myTableView.backgroundColor = .clear
        
        
        sendMessageView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        messageField.backgroundColor = UIColor.white
        messageField.delegate = self
        messageField.placeholder = "Enter Message Here"
        point1 = self.sendMessageView.center.y
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)

        
        initialFrame = self.view.frame
    //    point = self.sendMessageView.center.y - 250;
        
        
        
       
        setupDB()
        myTableView.delegate = self;
        myTableView.dataSource = self;
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        rows = messages.count
        return messages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell")
        
        
        
        let some = messages[indexPath.row].value as! Dictionary<String,String>
        
        print(messages[indexPath.row].key)
        
        cell?.textLabel?.text = some["text"]!
        cell?.textLabel?.backgroundColor = UIColor.clear
        
        cell?.detailTextLabel?.text = some["name"]!
        cell?.backgroundColor = UIColor.white.withAlphaComponent(0.5)
      
        
        return cell!
        
        
    }
    
    
    
    func setupDB()
    {
        ref = FIRDatabase.database().reference()
        ref_handle = self.ref.child("data").observe(.childAdded, with: {(snapshot) -> Void in

            
            self.messages.append(snapshot)
            self.myTableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .middle)
            self.myTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)

            print("did add")
        
        })
        
        
        ref.child("data").observe(.childRemoved, with: {(snapshot) -> Void in
            print("did delete")
        
            let index = self.getIndex(msg: snapshot)
            
        
         
                let indexPath = IndexPath(row: index, section: 0)
            
            
                
                
                self.myTableView.beginUpdates()
                self.messages.remove(at: index)
                self.myTableView.deleteRows(at:[indexPath] , with: .middle)
                
                
                self.myTableView.endUpdates()

        })
        
        ref.child("data").observe(.childChanged, with: { (snapshot) -> Void in
            
            let index = self.getIndex(msg: snapshot)
            
            
            let indexPath = IndexPath(row: index, section: 0)
            
            self.myTableView.beginUpdates()
            self.messages[index] = snapshot
            self.myTableView.reloadRows(at: [indexPath], with: .left)
            self.myTableView.endUpdates()
        
        
        
        
        })
        
    }
    
    func sendMessage(data:[String:String])
    {
        
        let user = FIRAuth.auth()?.currentUser
        if let some = user{
            self.ref.child("userClasses").child(some.uid).childByAutoId().setValue(data["text"])
          
            
        }
        self.ref.child("data").childByAutoId().setValue(data)
        
        
        
    }
    func updateMessage(data:[String:String],key:String)
    {
        
       // let key = ""
        
     //   let updates = ["/data/\(key)":data]
        ref.child("data/\(key)").setValue(data)
    }
  
    @IBAction func addData(_ sender: AnyObject) {
        
        
     
        let msg = self.messageField.text
        let some = user
        
        if let some1 = msg
        {
            self.sendMessage(data: ["name":some!,"text":some1])
            
        }
        
        
        self.messageField.text = ""
        
    }
    
    
    func getIndex(msg:FIRDataSnapshot) -> Int
    {
        
        for i in 0...self.messages.count-1
        {
            
            
            if(self.messages[i].key == msg.key)
            {
                return i
            }
            
            
        }
        return -1;
        
        
        
    }
    
    
    @IBAction func updateButton(_ sender: AnyObject) {
        
        
        
        let row = Int(rowField.text!)
        let updatename = updateNameField.text!
        let updatemsg = updateMessageField.text!
        
        
        
        let key = self.messages[row!].key
        
        
        let post = ["name":updatename,"text":updatemsg]
        
        self.updateMessage(data: post, key: key)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.frame = initialFrame
        textField.resignFirstResponder()
        self.sendMessageView.center.y = self.point1
        self.messageField.resignFirstResponder()
        self.myTableView.frame.size.height = self.origTable
        
        let indexP = IndexPath(row: self.rows-1, section: 0)
        self.myTableView.scrollToRow(at: indexP, at: .bottom, animated: true)

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let indexp = IndexPath(row: rows-1, section: 0)
        self.myTableView.scrollToRow(at: indexp, at: .bottom, animated: true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            
            if(!decide)
            {
                point = (self.sendMessageView.center.y - keyboardHeight)
                self.chotaTable = self.myTableView.bounds.height - keyboardHeight
                decide = true
            }
            
            UIView.animate(withDuration: 0.5, animations: {
            
                
                let indexP = IndexPath(row: self.rows-1, section: 0)
                
            
                self.myTableView.frame.size.height = self.chotaTable
                
                    self.myTableView.scrollToRow(at: indexP, at: .bottom, animated: true)
                self.sendMessageView.center.y = self.point
            
            
            
            })
            
        }
    }
    
    
    func showAlert(title:String, msg:String, error:Bool)
    {
        if(error)
        {
            
            self.showMessage(msg, type: .error, options: [
                .animation(.slide),
                .animationDuration(0.3),
                .autoHide(false),
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
    
    func checkConnectionState()
    {
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool , connected {
                print("Connected")
                self.showAlert(title: "Success", msg: "Connected to the Realtime Database", error: false)
            } else {
                print("Not connected")
                
                self.showAlert(title: "Error", msg: "Not Connected to the internet", error: true)
                
                
                
                
                
                
            }
        })
    }
}

