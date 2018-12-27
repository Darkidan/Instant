//
//  Feed.swift
//  Proj
//
//  Created by Darkidan on 23/11/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import Foundation

class Feed {
    let id: String
    let username: String
    let urlImage: String
    let timestemp: String //Date
    var likes = 0
    let text: String
    
    init(_id:String, _username:String, _urlImage:String, _timestemp:String,_text:String){
        id = _id
        username = _username
        urlImage = _urlImage
        timestemp = _timestemp
        text = _text
}

    init(json:[String:Any]) {
        id = json["id"] as! String
        username = json["username"] as! String
        urlImage = json["urlImage"] as! String
        timestemp = json["timestemp"] as! String //Date
        likes = json["likes"] as! Int
        text = json["text"] as! String
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["username"] = username
        json["urlImage"] = urlImage
        json["timestemp"] = timestemp
        json["likes"] = likes
        json["text"] = text
        return json
    }}
