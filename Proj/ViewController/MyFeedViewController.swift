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
        User_Manager.instance.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Sign", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
        }) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
}
