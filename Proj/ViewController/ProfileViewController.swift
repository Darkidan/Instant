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
    
    var userId:String?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userId != nil {
            user = User_Manager.instance.getUser(byId: userId!)
            username.text = user?.username
        }
    }
    
}
