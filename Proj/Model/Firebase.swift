//
//  Firebase.swift
//
//  Copyright © 2018 All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Firebase {
    var ref: DatabaseReference!
    let userDefault = UserDefaults.standard
    
    init() {
        ref = Database.database().reference()
    }
    
    func getAllFeedsAndObserve(from:Double, callback:@escaping ([Feed])->Void){
        let feedRef = ref.child("Feeds")
        let fbQuery = feedRef.queryOrdered(byChild: "lastUpdate").queryStarting(atValue: from)
        fbQuery.observe(.value) { (snapshot) in
            var data = [Feed]()
            if let value = snapshot.value as? [String:Any] {
                for (_, json) in value{
                    data.append(Feed(json: json as! [String : Any]))
                }
            }
            callback(data)
        }
    }
    
    func addNewFeed(feed:Feed){
        ref.child("Feeds").child(feed.id).setValue(feed.toJson())
    }
    
    func EditUser(user: User){
        ref.child("Users").child(user.id).setValue(user.toJson())
    }
    
    func ChangePass(password: String){
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if error == nil {
                print("Changed Password")
                // onSuccess()
            } else {
                print(error?.localizedDescription as Any)
                //onFailure(error)
            }
        }
    }
    
    func signInUser(email: String, password: String, onSuccess:@escaping ()->Void, onFailure:@escaping (Error?)->Void){
        Auth.auth().signIn(withEmail: email, password: password) {(user,error) in
            if error == nil {
                UserDefaults.standard.set(self.getUserId(), forKey: "uid")
                
                print("User has Signed In!")
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                onSuccess()
            } else {
                print(error?.localizedDescription as Any)
                onFailure(error)
            }
        }
    }
    
    func signUpUser(email: String, password: String, username: String, url: String, onSuccess:@escaping ()->Void, onFailure:@escaping (Error?)->Void){
        Auth.auth().createUser(withEmail: email, password: password){(user, error) in
            if error == nil {
                
                let newUser = User(_id: self.getUserId(), _username: username, _email: email, _url: url)
                UserDefaults.standard.set(self.getUserId(), forKey: "uid")
                self.ref.child("Users").child(self.getUserId()).setValue(newUser.toJson())
                print("User has Registerd!")
                self.userDefault.set(true, forKey: "usersignedup")
                self.userDefault.synchronize()
                onSuccess()
            } else {
                print(error?.localizedDescription as Any)
                onFailure(error)
            }
        }
    }
    
    func logoutSignUp(onSuccess:@escaping ()->Void, onFailure:@escaping (Error?)->Void){
        do {
            try Auth.auth().signOut()
            print("User logging out...")
            userDefault.removeObject(forKey: "usersignedup")
            userDefault.removeObject(forKey: "Username")
            userDefault.removeObject(forKey: "uid")
            userDefault.synchronize()
            onSuccess();
        } catch let error as NSError {
            print(error.localizedDescription)
            onFailure(error);
        }
    }
    
    func logoutSignIn(onSuccess:@escaping ()->Void, onFailure:@escaping (Error?)->Void){
        do {
            try Auth.auth().signOut()
            print("User logging out...")
            userDefault.removeObject(forKey: "usersignedin")
            userDefault.removeObject(forKey: "Username")
            userDefault.removeObject(forKey: "uid")
            userDefault.synchronize()
            onSuccess();
        } catch let error as NSError {
            print(error.localizedDescription)
            onFailure(error);
        }
    }
    
    func getUserByID(id: String, onSuccess:@escaping (User)->Void){
        ref.child("Users").child(getUserId()).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String:Any]{
                let user = User(json: value)
                onSuccess(user)
            }
        }
    }
    
    func getUsername(){
        let uid = UserDefaults.standard.string(forKey: "uid")
        ref.child("Users/\(uid!)").observeSingleEvent(of: .value){
            (DataSnapshot) in
            let value = DataSnapshot.value as? [String:Any]
            UserDefaults.standard.set(value!["username"]!, forKey: "Username")
            print("Username: \(UserDefaults.standard.string(forKey: "Username")!)")
        }
    }
    
    func getUserId()->String{
        return Auth.auth().currentUser!.uid
    }
    
    // IMAGE = STORAGE
    
    lazy var storageRef = Storage.storage().reference(forURL:"gs://instant-872f9.appspot.com")
    
    func saveImage(image:UIImage, text:(String), callback:@escaping (String?)->Void){
        
        let jpegData = image.jpegData(compressionQuality: 80)
        let imageRef = storageRef.child(text)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(jpegData!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    func deleteImage(text:(String)){
        let uid = UserDefaults.standard.string(forKey: "uid")
        // 1. delete the image from Storage
        print("name of image: \(text)")
        let avatarImage = storageRef.child(text)
        
        // Delete the file
        avatarImage.delete { error in
            if error != nil {
                // Uh-oh, an error occurred!
            } else {
                print("File deleted successfully")
            }
        }
        
        // 2. delete the image from database
        print(ref.child("Users").child(uid!).child("url"))
        ref.child("Users").child(uid!).child("url").setValue("")
        
    }
    
    func editImage(image:UIImage, text:(String), callback:@escaping (String?)->Void){
        deleteImage(text:text)
        
        let jpegData = image.jpegData(compressionQuality: 80)
        let imageRef = storageRef.child(text)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(jpegData!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
    
}
