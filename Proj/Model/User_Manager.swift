//
//  User_Manager.swift
//
//  Copyright © 2018 All rights reserved.
//

// Singlton

import Foundation

class User_Manager {
    
    var firebase = Firebase();
    static let instance:User_Manager = User_Manager()
    
    func signInUser(email: String, password: String, onSuccess:@escaping ()->Void, onFailure:@escaping (Error?)->Void){
        self.firebase.signInUser(email: email, password: password, onSuccess: {
            onSuccess()
        }, onFailure: { (error) in
            onFailure(error)
        })
    }
    func signUpUser(email: String, password: String, username: String, url: String ,onSuccess:@escaping ()->Void, onFailure:@escaping (Error?)->Void){
        self.firebase.signUpUser(email: email, password: password, username: username, url: url, onSuccess: {
            onSuccess()
        }, onFailure: { (error) in
            onFailure(error)
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
    
    func logoutSignUp(onSuccess:@escaping ()->Void, onFailure:@escaping (Error?)->Void){
        self.firebase.logoutSignUp(onSuccess: {
            onSuccess()
        }, onFailure: { (error) in
            onFailure(error)
        })
    }

    func logoutSignIn(onSuccess:@escaping ()->Void, onFailure:@escaping (Error?)->Void){
        self.firebase.logoutSignIn(onSuccess: {
            onSuccess()
        }, onFailure: { (error) in
            onFailure(error)
        })
    }
}
