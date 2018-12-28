//
//  ProfileViewController.swift
//  Instant
//
//  Copyright © 2018 All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    var user: User?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        User_Manager.instance.getUser { (user) in
            self.user = user
            self.username.text = user.username
            self.email.text = user.email
            self.spinner.isHidden = true
        }
    }
}
