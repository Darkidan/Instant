//
//  User.swift
//
//  Copyright © 2018 Instant. All rights reserved.

import Foundation

class User {
    let id:String
    let username:String
    var email:String
    var avatarUrl:String
    var friends:[User]?
    
    init(_id:String, _username:String, _email:String,_avatarUrl:String){
        id = _id
        username = _username
        email = _email
        avatarUrl = _avatarUrl
    }
    
    init(uid: String, dictionary: [String: Any]){
        self.id = uid
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.avatarUrl = dictionary["Avatarurl"] as? String ?? ""
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        username = json["username"] as! String
        email = json["email"] as! String
        avatarUrl = json["avatarUrl"] as! String
        
        var friendsId:[String]
        friendsId = json["friendsId"] as! [String]
        
        for _ in friendsId {
            //Todo for each id get friend from firebase
        }
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["username"] = username
        json["email"] = email
        json["avatarUrl"] = avatarUrl
        
        var friendsId = [String]()
        for friend in friends! {
            friendsId.append(friend.id)
        }
        json["friendsId"] = friendsId;
        
        return json
    }}
