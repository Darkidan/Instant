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

    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
}
    
    func getUser(byId:String)->User?{
       // let userID = Auth.auth().currentUser!.uid

        return nil
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
