//
//  MyFeedTableViewController.swift
//  Instant
//
//  Copyright © 2018 All rights reserved.
//

import UIKit
import FirebaseDatabase

class MyFeedTableViewController: UITableViewController {
    
    var data = [Feed]()
    var myfeedListener:NSObjectProtocol?
    let userid = UserDefaults.standard.string(forKey: "uid")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 450
        
        // happens only once - need to find out why!!!
        myfeedListener = UserManagerNotification.myfeedListNotification.observe(){ (data1:Any) in
            self.data = data1 as! [Feed]
            self.tableView.reloadData()
        }
        User_Manager.instance.getAllFeeds()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit{
        if myfeedListener != nil{
            UserManagerNotification.myfeedListNotification.remove(observer: myfeedListener!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyFeedTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "MyFeedCell", for: indexPath) as! MyFeedTableViewCell)
        cell.delegate = self

        // Check for each cell - if there is a true value for this feed
        
        // go to cell inside and change to full heart else empty
        
        let feed = data[indexPath.row]
        cell.likesAmount = feed.likes
        cell.feedID = feed.id
        cell.UsernameLabel.text = feed.username
        cell.textLabelC.text = feed.text
        if feed.lastUpdate != nil {
            cell.lastUpdate.text = CustomViewController.setDate(dateTime: feed.lastUpdate!)
        }
        
        // Check if already liked this feed then change to full heart
        
        let ref = Database.database().reference()
        
        ref.child("Likes/\(userid!)/\(feed.id)/Like").observeSingleEvent(of: .value) {
            (snapshot) in
            if let heartBool = snapshot.value as? Int {
                
                if ( heartBool == 1){
                    if let image = UIImage(named: "fullheart.png") {
                        cell.heartButton.setImage(image, for: .normal)
                    }
                } else {
                    if let image = UIImage(named: "icon-like.png") {
                        cell.heartButton.setImage(image, for: .normal)
                    }
                }
                
            }
        }
        
        // Update Likes Text
        ref.child("Feeds/\(feed.id)/likes").observeSingleEvent(of: .value) {
            (snapshot) in
            if let likesAmount = snapshot.value as? String {
                cell.likeButton.setTitle("Likes \(likesAmount)", for: .normal)
            }
        }
        
        // take it and use it in profileTableViewController
        cell.feedImage.image = UIImage(named: "wait_for_it")
        cell.feedImage.tag = indexPath.row
        if feed.urlImage != "" {
            User_Manager.instance.getImage(url: feed.urlImage) { (image:UIImage?) in
                if (cell.feedImage!.tag == indexPath.row){
                    if image != nil {
                        cell.feedImage.image = image!
                        cell.feedImage.clipsToBounds = true
                    }
                }
            }
        }
        return cell
    }
}

extension MyFeedTableViewController: FeedCellDelegate {
    
    // Add a check in cell to put full heart and change to true
    
    func handleLike(uid: String, feedID: String,likeCurrentState: Bool,currentHeartButton: UIButton,likesAmount: String) {
        
        let ref = Database.database().reference()
        
        let likes: Int = Int(likesAmount)!
        
        print(likes)
        
        if ( likeCurrentState ){
            
            // +1 Like , changeimage to full heart
            
            if let image = UIImage(named: "fullheart.png") {
                
                currentHeartButton.setImage(image, for: .normal)
                currentHeartButton.isEnabled = false
                ref.child("Likes/\(uid)/\(feedID)").setValue(["Like": true])
                ref.child("Feeds/\(feedID)/likes").setValue(String(likes+1))
                currentHeartButton.setTitle("\(likes+1) Likes",for: .normal)
                print("true")
            }
            
        }  else {
            
            // -1 like, change image to empty heart
            if let image = UIImage(named: "icon-like.png") {
                currentHeartButton.setImage(image, for: .normal)
                currentHeartButton.isEnabled = false
                ref.child("Likes/\(uid)/\(feedID)").setValue(["Like": false])
                if ( likes-1 < 0 ){
                    ref.child("Feeds/\(feedID)/likes").setValue("0")
                } else {
                    ref.child("Feeds/\(feedID)/likes").setValue(String(likes-1))
                }
                currentHeartButton.setTitle("\(likes-1) Likes",for: .normal)
                print(false)
            }
        }
        currentHeartButton.isEnabled = true
    }
    
}
