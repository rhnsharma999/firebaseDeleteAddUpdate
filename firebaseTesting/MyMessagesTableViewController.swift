//
//  MyMessagesTableViewController.swift
//  firebaseTesting
//
//  Created by Rohan Lokesh Sharma on 20/11/16.
//  Copyright © 2016 rohan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyMessagesTableViewController: UITableViewController {

    
    var messages = [FIRDataSnapshot]()
    var ref:FIRDatabaseReference!
    
    
    
    
    
    override func viewDidLoad() {
        setupDB()
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func setupDB()
    {
        
        
        let user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        if let some = user
        {
            ref.child("userClasses").child(some.uid).observe(.childAdded, with: {(snapshot) -> Void in
                
                
                self.messages.append(snapshot)
                self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .middle)
                self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
                
                
                
            })
        }
        
        
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
    //    let dict = messages[indexPath.row].value as! Dictionary<String,String>
        
        let message = messages[indexPath.row].value as! String
        
        cell?.textLabel?.text = message
        
        
        return cell!
        
    }

    
}
