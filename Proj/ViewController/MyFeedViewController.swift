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

    @IBOutlet weak var emailLabel: UILabel!
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileInfo()
    }
    
    func ProfileInfo(){
        if Auth.auth().currentUser != nil {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with:  { (snapshot)
                in
                
                guard let dict = snapshot.value as? [String:Any] else {return}
                
                let user = User(uid: uid, dictionary: dict)
                
                self.emailLabel.text = user.email
                
            }, withCancel: {(err) in
                print(err)
            })
    }
}
    
    @IBAction func signOutPressed(_ sender: Any) {
            //User_Manager.instance.logout()
        do {
            try Auth.auth().signOut()
            userDefault.removeObject(forKey: "usersignedin")
            userDefault.synchronize()
            let storyboard = UIStoryboard(name: "Sign", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
