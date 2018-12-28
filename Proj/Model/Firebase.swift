//
//  Firebase.swift
//  Proj
//
//  Created by Darkidan on 16/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Firebase {
    var ref: DatabaseReference!
    let userDefault = UserDefaults.standard


    init() {
       // FirebaseApp.configure()
        ref = Database.database().reference()
}
    
    func signInUser(email: String, password: String, onSuccess:@escaping ()->Void, onFalire:@escaping (Error?)->Void){
        Auth.auth().signIn(withEmail: email, password: password) {(user,error) in
            if error == nil {
                // Signed in
                print("User has Signed In!")
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                
                onSuccess();
            } else {
                print(error?.localizedDescription as Any)
                onFalire(error);
            }
        }
    }
    
    func getUserByID(id: String, onSuccess:@escaping (User)->Void){
        ref.child("Users").child("123456").observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value as Any)
            if let value = snapshot.value as? [String:Any]{
                let user = User(json: value)
                onSuccess(user)
            }
        }
    }
    
    func getUserId()->String{
        return Auth.auth().currentUser!.uid
    }
    
    
    
    // Need Fixing
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
