//
//  LoginViewController.swift
//  Instant
//
//  Copyright © 2018 All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = true

        let usernameImage = UIImage(named: "username_icon")
        addImagetoPlaceHolder(textfield: email, andImage: usernameImage!)
        
        let passwordImage = UIImage(named: "password_icon")
        addImagetoPlaceHolder(textfield: password, andImage: passwordImage!)
        
    }
    
    func signInUser(email: String, password: String){
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        User_Manager.instance.signInUser(email: email, password: password, onSuccess: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
        }) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
    
    @IBAction func SignIn(_ sender: Any) {
        signInUser(email: email.text!, password: password.text!)
    }
    
    func addImagetoPlaceHolder(textfield: UITextField, andImage img: UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        textfield.leftView = leftImageView
        textfield.leftViewMode = .always
    }
}
