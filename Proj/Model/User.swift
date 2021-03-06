//
//  User.swift
//
//  Copyright © 2018-2019 All rights reserved.
//

import Foundation

class User {
    let id:String
    var username:String
    let email:String
    var url:String
    var feeds:[Feed]?
    
    init(_id:String, _username:String, _email:String,_url:String){
        id = _id
        username = _username
        email = _email
        url = _url
        feeds = [Feed]()
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        username = json["username"] as! String
        email = json["email"] as! String
        url = json["url"] as! String
        feeds = User_Manager.instance.getFeedsFromStringList(feedsString: json["feed"] as? [String])
    }

    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["username"] = username
        json["email"] = email
        json["url"] = url
        
        // feeds by id
        var feedsString = [String]()

        for f in feeds ?? []{
            feedsString.append(f.id)
        }
        json["feed"] = feedsString
 
        return json
    }}
