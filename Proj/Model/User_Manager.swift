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
    
    var firebase = Firebase();
    static let instance:User_Manager = User_Manager()
    
    func saveUser(user:User){
        //save user local
    }
    
    func signInUser(email: String, password: String, onSuccess:@escaping ()->Void, onFalire:@escaping (Error?)->Void){
        self.firebase.signInUser(email: email, password: password, onSuccess: {
            onSuccess()
        }, onFalire: { (error) in
            onFalire(error)
        })
    }
    
    func getUser(onSuccess:@escaping (User)->Void){
        firebase.getUserByID(id: self.getUserId()) { (user) in
            onSuccess(user)
        }
    }
    
    func getUserId()->String{
        return firebase.getUserId()
    }

    
    // Need Fixing
    func logout() {
        firebase.logout()
    }
    
   
}
