//
//  MyFeedViewController.swift
//  Proj
//
//  Created by Darkidan on 04/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyFeedViewController: UIViewController {

    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // guard  let email = Auth.auth().currentUser?.email else { return }
       // email.text = email
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            userDefault.removeObject(forKey: "usersignedin")
            userDefault.synchronize()
            let storyboard = UIStoryboard(name: "Sign", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
