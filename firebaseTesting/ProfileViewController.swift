//
//  ProfileViewController.swift
//  firebaseTesting
//
//  Created by Rohan Lokesh Sharma on 07/12/16.
//  Copyright © 2016 rohan. All rights reserved.
//

import UIKit

import Firebase
class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    let imagePicker = UIImagePickerController()
    var ref:FIRStorageReference!
    
    
    @IBOutlet var progressBar:UIProgressView!
    @IBOutlet var profile_image:UIImageView!
    @IBOutlet var nameLable:UILabel!
    @IBOutlet var emailLabel:UILabel!
    

    override func viewDidLoad() {
        
        
        
        
        self.profile_image.layer.borderColor = UIColor.white.cgColor
        self.profile_image.layer.borderWidth = 1.5
        self.profile_image.layer.cornerRadius = self.profile_image.bounds.width/2
        
        self.profile_image.layer.masksToBounds = true
        imagePicker.delegate = self;
        imagePicker.sourceType = .photoLibrary
        self.getImage()
        super.viewDidLoad()
        

    }
    
    func uploadImageToFirebase(data:Data)
    {
        guard let user = FIRAuth.auth()?.currentUser else{return}
        
         ref = FIRStorage.storage().reference().child(user.uid).child("profile.jpg")
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        
       let task =  ref.put(data, metadata: metaData, completion: { (metadata,error) in
            
            if(error != nil){
                print(error?.localizedDescription)
            }
            else{
                print("success upload")
        
            }
        })
        
        task.observe(.progress, handler: { (snapshot) in
        
            guard let progress = snapshot.progress else{return}
            
            self.progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
            
            
        
        
        
        })
    }
    
    
    func getImage()
    {
        guard let user = FIRAuth.auth()?.currentUser else{return}

        ref = FIRStorage.storage().reference().child(user.uid).child("profile.jpg")
        let someshit = ref.data(withMaxSize: 1*1024*1024*1024, completion: { (data,error) in
        
            if(error != nil)
            {
                print(error?.localizedDescription)
            }
            else
            {
                guard let image = UIImage(data: data!) else{return}
                self.profile_image.image = image;
                
            }
        
        })
        
        someshit.observe(.progress, handler: { (snapshot) in
        
            
            guard let progress = snapshot.progress else {return}
        
            self.progressBar.progress = Float(progress.fractionCompleted)
        
        })
       
       
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{return}
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
        self.uploadImageToFirebase(data: imageData)
        profile_image.contentMode = .scaleToFill
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func loadImage(_ sender: Any) {
        
        
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
 

}
