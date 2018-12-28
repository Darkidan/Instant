//
//  User.swift
//
//  Copyright © 2018 All rights reserved.

import Foundation

class User {
    let id:String
    let username:String
    var email:String
    var url:String
    // TODO : Friends
    //var friends:[User]?
    
    init(_id:String, _username:String, _email:String,_url:String){
        id = _id
        username = _username
        email = _email
        url = _url
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        username = json["username"] as! String
        email = json["email"] as! String
        url = json["url"] as! String
        
    //    var friendsId:[String]
     //   friendsId = json["friendsId"] as! [String]
        
     //   for _ in friendsId {
            //Todo for each id get friend from firebase
      //  }
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["username"] = username
        json["email"] = email
        json["url"] = url
        
     //   var friendsId = [String]()
     //   for friend in friends! {
     //       friendsId.append(friend.id)
      //  }
      //  json["friendsId"] = friendsId;
        
        return json
    }}
