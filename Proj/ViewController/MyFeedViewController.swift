//
//  MyFeedViewController.swift
//  Instant
//
//  Copyright © 2018 All rights reserved.
//

import UIKit

class MyFeedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "usersignedin"){
            User_Manager.instance.logoutSignIn(onSuccess: {
                let storyboard = UIStoryboard(name: "Sign", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.present(vc!, animated: true, completion: nil)
            }) { (error) in
                print(error?.localizedDescription as Any)
            }
        }
        else {
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
