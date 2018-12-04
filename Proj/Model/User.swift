//
//  User.swift
//  Proj
//
//  Created by Darkidan on 23/11/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import Foundation

class User {
    let id:String
    let username:String
    var password:String
    var email:String
    // var avatar:ImageView
    
    init(_id:String, _username:String, _password:String, _email:String){
        id = _id
        username = _username
        password = _password
        email = _email
    }
}
