//
//  User_Manager.swift
//  Proj
//
//  Created by Darkidan on 29/11/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

// Singlton

import Foundation

class User_Manager {
    var user:User?
    
    static let instance:User_Manager = User_Manager()
    
    func getUser()->User?{
        if user == nil {
            //Todo get user from local save
        }
        return self.user
    }
    
    func saveUser(user:User){
        //save user local
    }
    
   
}
