//
//  ViewController.swift
//  firebaseTesting
//
//  Created by Rohan Lokesh Sharma on 05/10/16.
//  Copyright © 2016 rohan. All rights reserved.
//

import UIKit

import Firebase
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var messageField: UITextField!
    @IBOutlet var myTableView:UITableView!
    var field:UITextField!
    var point:CGFloat!
    @IBOutlet var rowField: UITextField!
    
    var initialFrame:CGRect!
   
    @IBOutlet var updateNameField: UITextField!
    @IBOutlet var updateMessageField: UITextField!
    var messages = [FIRDataSnapshot]()
    var ref:FIRDatabaseReference!
    var ref_handle:FIRDatabaseHandle!
    

    override func viewDidLoad() {

        FIRDatabase.database().persistenceEnabled = true
        initialFrame = self.view.frame
        point = self.view.center.y - 250;
        
        
        
       
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
        return messages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell")
        
        
        
        let some = messages[indexPath.row].value as! Dictionary<String,String>
        
        print(messages[indexPath.row].key)
        
        cell?.textLabel?.text = some["text"]!
        
        cell?.detailTextLabel?.text = some["name"]!
        
        
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
        self.ref.child("data").childByAutoId().setValue(data)
    }
    func updateMessage(data:[String:String],key:String)
    {
        
       // let key = ""
        
     //   let updates = ["/data/\(key)":data]
        ref.child("data/\(key)").setValue(data)
    }
  
    @IBAction func addData(_ sender: AnyObject) {
        
        
        let name = self.nameField.text
        let msg = self.messageField.text
        
        if let some = name
        {
            if let some1 = msg
            {
                self.sendMessage(data: ["name":some,"text":some1])
                
            }
        }
        
    
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
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
        
            self.view.center.y = self.point
        
        
        
        })
    }
}

