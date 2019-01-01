//
//  EditProfileViewController.swift
//  Proj
//
//  Created by Darkidan on 30/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var chooseAvatar: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var confirmNewPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        User_Manager.instance.getUser { (user) in
            self.usernameText.text = user.username
            self.spinner.isHidden = true
        }
    }
    

    @IBAction func chooseAvatar(_ sender: Any) {
    }
    @IBAction func editProfile(_ sender: Any) {
    }

}
