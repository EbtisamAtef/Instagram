//
//  ViewController.swift
//  Instgram
//
//  Created by Ebtisam on 10/20/18.
//  Copyright © 2018 Ebtisam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    let plusPhotoButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hanleplusPhotoButton), for: .touchUpInside)
        return button
    }()
    
    
    let emailTextField:UITextField = {
        let tf=UITextField()
        tf.backgroundColor = UIColor(white: 0 , alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(hanleChangeSignUpButton), for: .editingChanged)
        return tf
    }()

    
    let userTextField:UITextField = {
        let tf=UITextField()
        tf.backgroundColor = UIColor(white: 0 , alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.placeholder = "Username"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(hanleChangeSignUpButton), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField:UITextField = {
        let tf=UITextField()
        tf.backgroundColor = UIColor(white: 0 , alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(hanleChangeSignUpButton), for: .editingChanged)
        return tf
    }()
    
    let signUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        
        setUpInputFields()
        
    }

    
    fileprivate  func setUpInputFields(){
        let stackview = UIStackView(arrangedSubviews: [emailTextField, userTextField, passwordTextField, signUpButton])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.spacing = 10
        view.addSubview(stackview)
        
        NSLayoutConstraint.activate([
            stackview.heightAnchor.constraint(equalToConstant: 200),
            stackview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stackview.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20)
            ])
        
    }
    
    @objc func hanleplusPhotoButton(){
        //this code to choose photo from you gallery
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true , completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // this code will excute when you selected an image for showing select image on profileimage
        if let edietImage = info["UIImagePickerControllerEdietImage"] as? UIImage{
            plusPhotoButton.setImage(edietImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            plusPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true , completion: nil)
    }
    
    
    @objc func hanleChangeSignUpButton(){
        
        let email = emailTextField.text
        let password = passwordTextField.text
        let username = userTextField.text
        
        if (email?.isEmpty)! || (password?.isEmpty)! || (username?.isEmpty)! {
            signUpButton.backgroundColor = #colorLiteral(red: 0.9294892132, green: 0.1240284118, blue: 0.1453440693, alpha: 1)
            signUpButton.isEnabled = false
        }else{
            signUpButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            signUpButton.isEnabled = true
        }
    }
    
    
    @objc func handleSignUp(){
        
        guard let email = emailTextField.text, email.characters.count > 0 else { return}
        guard let username = userTextField.text, username.characters.count > 0 else {return}
        guard let password = passwordTextField.text, password.characters.count > 0 else {return}

        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userid = Auth.auth().currentUser?.uid
        
        Auth.auth().createUser(withEmail: email, password: password) { (user , error) in
            
            if let err = error{
                print("not saved \(err)")
                return
            }
            print("saved  \(String(describing: userid!))")
        }
        
        
        if let profileimage = self.plusPhotoButton.imageView?.image , let imagedata = UIImageJPEGRepresentation(profileimage, 0.1){
            
            var storageref = Storage.storage().reference(forURL: "gs://instgram-ae7fc.appspot.com").child("user_profile").child(userid!)
            storageref.putData(imagedata, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    return
                }
                
                storageref.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print("faild to upload image")
                        return
                    }
                    
                    let profilePicUrl = url?.absoluteString
                    let newuser = ref.child("users").child(userid!)
                    newuser.setValue(["username": self.userTextField.text!, "mail":self.emailTextField.text!,"userImage":profilePicUrl])
                    
                    
                })
                
                
                
            })
        }
        
        
        
        let newuser = ref.child("users").child(userid!)
        newuser.setValue(["username": self.userTextField.text!, "mail":self.emailTextField.text!])
        
        }
    
  

}

