//
//  LoginViewController.swift
//  Proj
//
//  Created by Darkidan on 02/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var addImageBtn: UIButton!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let userDefault = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usernameImage = UIImage(named: "username_icon")
        addImagetoPlaceHolder(textfield: email, andImage: usernameImage!)
        
        let passwordImage = UIImage(named: "password_icon")
        addImagetoPlaceHolder(textfield: password, andImage: passwordImage!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "usersignedin"){
            performSegue(withIdentifier: "myfeed", sender: self)
        }
    }
    
    
    func signInUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) {(user,error) in
            if error == nil {
                // Signed in
                print("User has Signed In!")
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "myfeed", sender: self)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func SignIn(_ sender: Any) {
        signInUser(email: email.text!,password: password.text!)
    }
    
    func addImagetoPlaceHolder(textfield: UITextField, andImage img: UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        textfield.leftView = leftImageView
        textfield.leftViewMode = .always
    }
}

