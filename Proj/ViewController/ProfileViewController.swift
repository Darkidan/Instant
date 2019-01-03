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
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var user: User?
    
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
            
            if user.url != "" {
                User_Manager.instance.getImageProfile(url: user.url) { (image:UIImage?) in
                    if image != nil {
                        self.imageAvatar.image = image!
                    }
                }
            }
            self.spinner.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageAvatar.contentMode = .scaleAspectFill
        self.imageAvatar.layer.cornerRadius = 50
        self.imageAvatar.clipsToBounds = true
    }
    
    @IBAction func logout(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "usersignedin"){
            User_Manager.instance.logoutSignIn(onSuccess: {
                let storyboard = UIStoryboard(name: "Sign", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.present(vc!, animated: true, completion: nil)
            }) { (error) in
                print(error?.localizedDescription as Any)
            }
        }
        else if UserDefaults.standard.bool(forKey: "usersignedup"){
            User_Manager.instance.logoutSignUp(onSuccess: {
                let storyboard = UIStoryboard(name: "Sign", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.present(vc!, animated: true, completion: nil)
            }) { (error) in
                print(error?.localizedDescription as Any)
            }
        }
    }
}
