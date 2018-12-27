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
    static let instance:User_Manager = User_Manager()
    
    var firebase = Firebase();

    ///////////////////////////
    func getUser(byId:String)->User?{
        return firebase.getUser(byId:byId)
    }
    
    func saveUser(user:User){
        //save user local
    }
    
    // Need Fixing
    func logout() {
        firebase.logout()
    }
    
   
}
