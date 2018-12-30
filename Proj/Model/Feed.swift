//
//  Feed.swift
//
//  Copyright © 2018 All rights reserved.
//

import Foundation
import Firebase

class Feed {
    let id: String
    let username: String
    let urlImage: String
    var likes: String
    let text: String
    var lastUpdate:Double?
    
    init(_id:String, _username:String, _urlImage:String = "", _likes:String ,_text:String){
        id = _id
        username = _username
        urlImage = _urlImage
        likes = _likes
        text = _text
}

    init(json:[String:Any]) {
        id = json["id"] as! String
        username = json["username"] as! String
        urlImage = json["urlImage"] as! String
        likes = json["likes"] as! String
        text = json["text"] as! String
        
        if json["lastUpdate"] != nil {
            if let lud = json["lastUpdate"] as? Double{
                lastUpdate = lud
            }
        }
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["username"] = username
        json["urlImage"] = urlImage
        json["likes"] = likes
        json["text"] = text
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }}
