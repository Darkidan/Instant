//
//  Firebase.swift
//
//  Copyright © 2018-2019 All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Firebase {
    var ref: DatabaseReference!
    let userDefault = UserDefaults.standard
    
    var Friends = [String]()
    var FriendsImg = [String]()
    var EveryUser = [String]()
    var FriendsUID = [String]() // used to filter feeds
    
    init() {
        ref = Database.database().reference()
    }
    
    func getAllFeedsAndObserve(from:Double, callback:@escaping ([Feed])->Void){
        let feedRef = ref.child("Feeds")
        let fbQuery = feedRef.queryOrdered(byChild: "lastUpdate").queryStarting(atValue: from)
        fbQuery.observe(.value) { (snapshot) in
            // find my friends + adds to firends uid array my uid
            self.ref.child("Friends/\(self.getUserId())").observe(.value, with: { (DataSnapshot) in
                
                for child in DataSnapshot.children {
                    let firstSnap = child as! DataSnapshot
                    let v = firstSnap.value as? String
                    self.FriendsUID.append(v!)
                }
                
                self.FriendsUID.append(self.getUserId()) // Adding me , so i can see my feed also
                
                //print("Friends and me: \(self.FriendsUID.count)")
                
                // check for each feed if its uid is contained in friends array
                var data = [Feed]()
                var bool = false
                var feedID: String?
                for feed in snapshot.children{ // for every feed
                    let firstSnap = feed as! DataSnapshot
                    
                    for item in firstSnap.children{ // for every key value
                        let secondSnap = item as! DataSnapshot
                        let key = secondSnap.key
                        let val = secondSnap.value as? String
                        
                        if ( key == "id"){
                            feedID = val!
                        }
                        if ( key == "uid" ){
                            if ( self.FriendsUID.contains(val!)){
                                //print("Found Post From: \(val!)")
                                bool = true
                                break
                            } else {
                                bool = false
                            }
                        }
                    } // end for
                    
                    if ( bool ){
                        if let value = snapshot.childSnapshot(forPath: feedID!).value as? [String:Any] {

                            data.append(Feed(_id: value["id"]! as! String,
                                             _username: value["username"]! as! String,
                                             _urlImage: value["urlImage"]! as! String,
                                             _likes: value["likes"]! as! String,
                                             _text: value["text"]! as! String,
                                             _uid: value["uid"]! as! String,
                                             _lastUpdate: value["lastUpdate"]! as! Double))
                        }
                    }
                } // end feed for
                //print("Data amount: \(data.count)")
                callback(data.reversed())
            })
            
        }
    }
    
    /*
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
    }*/
    
    func addNewFeed(feed:Feed){
        ref.child("Feeds").child(feed.id).setValue(feed.toJson())
    }
    
    func UpdateUser(user: User){
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
                print("User has Signed In!")
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.set(self.getUserId(), forKey: "uid")
                User_Manager.instance.getUserAndFeeds(callback: {})
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
                self.userDefault.set(self.getUserId(), forKey: "uid")
                self.ref.child("Users").child(self.getUserId()).setValue(newUser.toJson())
                print("User has Registerd!")
                self.userDefault.set(true, forKey: "usersignedup")
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
            userDefault.removeObject(forKey: "uid")

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
            userDefault.removeObject(forKey: "uid")
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
    
    func getFeedByID(feedId: String, onSuccess:@escaping (Feed)->Void){
        ref.child("Feeds").child(feedId).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String:Any]{
                let feed = Feed(json: value)
                onSuccess(feed)
            }
        }
    }
    
    
    func getFriendsList() {
        ref.child("Friends/\(getUserId())").observe(.value){(DataSnapshot) in
            let friendsData = DataSnapshot.value as? [String:Any]
            if (friendsData != nil){
                for friendUID in friendsData!{
                    self.ref.child("Users/\(friendUID.value)").observe(.value){ (DataSnapshot2) in
                        let userData = DataSnapshot2.value as? [String:Any]
                        if ( DataSnapshot2.childrenCount != 0 ){
                            self.Friends.append(userData!["username"] as! String)
                            self.FriendsImg.append(userData!["url"] as! String)
                        }
                    }
                }
            }
        }
    }
    
    func getUserId()->String{
        return Auth.auth().currentUser!.uid
    }
    
    // IMAGE = STORAGE
    
    lazy var storageRef = Storage.storage().reference(forURL:"gs://instant-927b1.appspot.com")
    
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
        let uid = User_Manager.instance.user?.id
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
        ref.child("Users").child(uid!).child("url").setValue("")
        
    }
    
    func editImage(image:UIImage, text:(String), callback:@escaping (String?)->Void){
        if text != ""{
            deleteImage(text:text)
        }
        
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
    
    func getFriendsList(tableView: UITableView,onSuccess:@escaping (UITableView)->Void) {
        
        ref.child("Friends/\(getUserId())").observe(.value){
            (DataSnapshot) in
            let friendsData = DataSnapshot.value as? [String:Any]
            if (friendsData != nil){
                for friendUID in friendsData!{
                    self.ref.child("Users/\(friendUID.value)").observe(.value){ (DataSnapshot2) in
                        let userData = DataSnapshot2.value as? [String:Any]
                        if ( DataSnapshot2.childrenCount != 0 ){
                            self.Friends.append(userData!["username"] as! String)
                            self.FriendsImg.append(userData!["url"] as! String)
                            onSuccess(tableView)
                        }
                    }
                }
            }
        }
    }
    

    func getEveryUserArray() -> [String] {
        return EveryUser
    }
    
    func getFriendsImgArray() -> [String] {
        return FriendsImg
    }
    
    func getFriendsArray() -> [String] {
        return Friends
    }
    
    func saveFeedsForUser(onSuccess:@escaping ([String])->Void){
        var currentFeeds = [String]()
        ref.child("Users/\(getUserId())/feed").observeSingleEvent(of: .value, with: { (DataSnapshot) in
            for child in DataSnapshot.children{
                let firstSnap = child as! DataSnapshot
                currentFeeds.append(firstSnap.value as! String)
            }
            onSuccess(currentFeeds)
        })
}
    
    func getUserList() {
        ref.child("Users").observe(.value, with: { (DataSnapshot) in
            for child in DataSnapshot.children{
                let firstSnap = child as! DataSnapshot
                let k = firstSnap.key
                
                if ( k != self.getUserId() ){// Dont take my user as a friend
                    for item in firstSnap.children {
                        let secondSnap = item as! DataSnapshot
                        let key = secondSnap.key
                        let val = secondSnap.value
                        if (key == "username"){
                            self.EveryUser.append((val as! String))
                        }
                    }
                }
                
            }
        })
    }
}
