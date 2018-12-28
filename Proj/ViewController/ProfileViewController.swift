//
//  ProfileViewController.swift
//  Proj
//
//  Created by Darkidan on 16/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    var user:User?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        User_Manager.instance.getUser { (user) in
            self.user = user
            DispatchQueue.main.async {
                self.username.text = user.username
                self.email.text = user.email
                self.spinner.isHidden = true
            }
            
            print(user.username)
            //TODO: ADD Spinner. IF done Spiner is hidden
        }
    }
    
}
