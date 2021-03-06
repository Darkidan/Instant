//
//  User_Manager.swift
//
//  Copyright © 2018-2019 All rights reserved.
//

import Foundation
import UIKit

class User_Manager {
    var sql = User_Manager_SQL();
    var firebase = Firebase();
    static let instance:User_Manager = User_Manager()
    var feeds = [Feed]()
    var user:User?
    
    func signInUser(email: String, password: String, onSuccess:@escaping ()->Void, onFailure:@escaping (Error?)->Void){
        self.firebase.signInUser(email: email, password: password, onSuccess: {
            self.setUser()
            onSuccess()
        }, onFailure: { (error) in
            onFailure(error)
        })
    }
    func signUpUser(email: String, password: String, username: String, url: String ,onSuccess:@escaping ()->Void, onFailure:@escaping (Error?)->Void){
        self.firebase.signUpUser(email: email, password: password, username: username, url: url, onSuccess: {
            self.user = User(_id: self.getUserId(), _username: username, _email: email, _url: url)
            onSuccess()
        }, onFailure: { (error) in
            onFailure(error)
        })
    }
    
    func getProfileFeed(onSuccess:@escaping ()-> Void){
        firebase.getProfileFeed {
            onSuccess()
        }
    }
    
    func getFeedArray()->[Feed]{
        return firebase.getFeedArray()
    }
    
    func handleFriendRequest(name: String,buttonText: String,currentCell: CustomCell,indexPath: IndexPath,onSuccess:@escaping (_ action:String) -> Void){
        firebase.handleFriendRequest(name: name, buttonText: buttonText, currentCell: currentCell, indexPath: indexPath) { (action) in
            onSuccess(action)
        }
    }
    
    func setUser(){
        User_Manager.instance.getUser { (user) in
            self.user = user
        }
    }
    
    func getUser(onSuccess:@escaping (User)->Void){
        firebase.getUserByID(id: self.getUserId()) { (user) in
            onSuccess(user)
        }
    }
    
    func getFeed(feedId: String,onSuccess:@escaping (Feed)->Void){
        firebase.getFeedByID(feedId: feedId) { (feed) in
            onSuccess(feed)
        }
    }
    
    func getUserId()->String{
        return firebase.getUserId()
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
    
    func getAllFeeds(onFinish:@escaping ()->Void){
        //1. read local feeds last update date
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
            
            //4. update the local feeds last update date
            Feed.setLastUpdateDate(database: self.sql.database, date: lastUpdated)
            
            //5. get the full data
            let feedFullData = Feed.getAll(database: self.sql.database)
            
            //6. notify observers with full data
            UserManagerNotification.myfeedListNotification.notify(data: feedFullData)
            
            self.feeds = feedFullData;
            onFinish()
        }
    }
    
    func getUserAndFeeds(callback:@escaping ()->Void){
        User_Manager.instance.getAllFeeds {
            User_Manager.instance.setUser()
        }
        callback();
    }
    
    func setHeart(feed: Feed,cell:MyFeedTableViewCell,onSuccess: @escaping (String)->Void ){
        firebase.setHeart(feed: feed, cell: cell,onSuccess:{(b) in
            onSuccess(b)
        })
    }
    
    func setLikesAmount(feed: Feed,cell:MyFeedTableViewCell){
        firebase.setLikesAmount(feed: feed,cell: cell)
    }
    
    func getFeedsFromStringList(feedsString: [String]?) -> [Feed]{
        if feedsString == nil {
            return []
        }
        
        var feed = [Feed]()
        for f in self.feeds {
            if feedsString!.contains(f.id){
                feed.append(f);
            }
        }
        return feed
    }
    
    func addNewFeed(feed:Feed){
        firebase.addNewFeed(feed: feed)
    }
    
    func UpdateUser(){
        firebase.UpdateUser(user: self.user!)
    }
    
    func updateFeed(feedID:String,text: String,url: String?){
        firebase.updateFeed(feedID: feedID, text: text, url: url)
    }
    
    func ChangePass(password: String){
        firebase.ChangePass(password: password)
    }
    
    func saveImage(image:UIImage, text:(String),callback:@escaping (String?)->Void){
        firebase.saveImage(image: image, text: text, callback: callback)
    }
    
    func editImage(image:UIImage, text:(String),callback:@escaping (String?)->Void){
        firebase.editImage(image: image, text: text, callback: callback)
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        let _url = URL(string: url)
        let localImageName = _url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
            print("Image(cache): \(localImageName)")
        } else {
            firebase.getImage(url: url){(image:UIImage?) in
                if (image != nil){
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                callback(image)
                print("Image(firebase): \(localImageName)")
            }
        }
    }
    
    func getImageProfile(url:String, callback:@escaping (UIImage?)->Void){
        let _url = URL(string: url)
        let localImageName = _url!.lastPathComponent
        firebase.getImage(url: url){(image:UIImage?) in
            if (image != nil){
                self.saveImageToFile(image: image!, name: localImageName)
            }
            callback(image)
        }
    }
    
    func plusLikes(uid: String,feedID: String,likes: Int){
        firebase.plusLikes(uid: uid, feedID: feedID, likes: likes)
    }
    
    func minusLikes(uid: String,feedID: String,likes: Int){
        firebase.minusLikes(uid: uid, feedID: feedID, likes: likes)
    }
    
    func getFriendsList(tableView: UITableView,onSuccess:@escaping (UITableView)->Void) {
        firebase.getFriendsList(tableView: tableView, onSuccess: {_ in
            onSuccess(tableView)
        })
    }
    
    func getEveryUserArray() -> [String] {
        return firebase.getEveryUserArray()
    }
    
    func getFriendsArray() -> [String] {
        return firebase.getFriendsArray()
    }
    
    func getUserList(onSuccess:@escaping ([String])->Void) {
        firebase.getUserList { (list) in
            onSuccess(list)
        }
    }
    
    func saveFeedsForUser(onSuccess:@escaping ([String])->Void) {
        firebase.saveFeedsForUser(onSuccess: { (feeds) in
            onSuccess(feeds)
        })
    }
    
    func saveImageToFile(image: UIImage, name: String){
        let data = image.jpegData(compressionQuality: 0.8) ?? image.pngData()
        let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
        try? data!.write(to: directory!.appendingPathComponent(name)!)
    }
    
    func getImageFromFile(name: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(name).path)
        }
        return nil
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
