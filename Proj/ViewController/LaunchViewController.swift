//
//  LaunchViewController.swift
//  Instant
//
//  Copyright © 2018-2019 All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "usersignedin") || UserDefaults.standard.bool(forKey: "usersignedup"){
            User_Manager.instance.getUserAndFeeds {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.present(vc!, animated: true, completion: nil)
            }
        } else {
            let storyboard = UIStoryboard(name: "Sign", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
        }
    }
}
