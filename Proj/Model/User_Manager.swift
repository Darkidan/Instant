//
//  User_Manager.swift
//
//  Copyright © 2018 All rights reserved.
//

import Foundation
import UIKit

class User_Manager {
    
    var sql = User_Manager_SQL();
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
    
    func getUsername(){
        firebase.getUsername()
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
    
    func getAllFeeds(){
        //1. read local students last update date
        var lastUpdated = Feed.getLastUpdateDate(database: sql.database)
        lastUpdated += 1;
        
        //2. get updates from firebase and observe
        firebase.getAllFeedsAndObserve(from:lastUpdated){ (data:[Feed]) in
            //3. write new records to the local DB
            for feed in data{
                Feed.addNew(database: self.sql.database, feed: feed)
                if (feed.lastUpdate != nil && feed.lastUpdate! > lastUpdated){
                    lastUpdated = feed.lastUpdate!
                }
            }
            
            //4. update the local students last update date
            Feed.setLastUpdateDate(database: self.sql.database, date: lastUpdated)
            
            //5. get the full data
            let feedFullData = Feed.getAll(database: self.sql.database)
            
            //6. notify observers with full data
            UserManagerNotification.myfeedListNotification.notify(data: feedFullData)
        }
    }
    
    func addNewFeed(feed:Feed){
        firebase.addNewFeed(feed: feed);
    }
    
    func saveImage(image:UIImage, text:(String),callback:@escaping (String?)->Void){
        firebase.saveImage(image: image, text: text, callback: callback)
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let _url = URL(string: url)
        let localImageName = _url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
            print("got image from cache \(localImageName)")
        }else{
            //2. get the image from Firebase
            firebase.getImage(url: url){(image:UIImage?) in
                if (image != nil){
                    //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
                print("got image from firebase \(localImageName)")
            }
        }
    }
    
    /// File handling
    func saveImageToFile(image:UIImage, name:String){
        if let data = image.jpegData(compressionQuality: 80) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
}

class UserManagerNotification{
    static let myfeedListNotification = MyNotification<[Feed]>("Instant.Project.feedlist")
    
    class MyNotification<T>{
        let name:String
        var count = 0;
        
        init(_ _name:String) {
            name = _name
        }
        func observe(cb:@escaping (T)->Void)-> NSObjectProtocol{
            count += 1
            return NotificationCenter.default.addObserver(forName: NSNotification.Name(name),
                                                          object: nil, queue: nil) { (data) in
                                                            if let data = data.userInfo?["data"] as? T {
                                                                cb(data)
                                                            }
            }
        }
        
        func notify(data:T){
            NotificationCenter.default.post(name: NSNotification.Name(name),
                                            object: self,
                                            userInfo: ["data":data])
        }
        
        func remove(observer: NSObjectProtocol){
            count -= 1
            NotificationCenter.default.removeObserver(observer, name: nil, object: nil)
        }
    }
}
