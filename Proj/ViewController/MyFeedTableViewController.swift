//
//  MyFeedTableViewController.swift
//  Instant
//
//  Copyright © 2018-2019 All rights reserved.
//

import UIKit

class MyFeedTableViewController: UITableViewController {
    
    var data = [Feed]()
    var myfeedListener:NSObjectProtocol?
    let userid = UserDefaults.standard.string(forKey: "uid")
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(Request), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 450
        
        myfeedListener = UserManagerNotification.myfeedListNotification.observe(){ (data:Any) in
            self.data = data as! [Feed]
            self.tableView.reloadData()
        }
        tableView.refreshControl = refresher
    }
    
    @objc
    func Request(){
        refresher.endRefreshing()
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
        
        User_Manager.instance.setHeart(feed: feed, cell: cell,onSuccess:{(b) in
            
            if let image = UIImage(named: b) {
                cell.heartButton.setImage(image, for: .normal)
            }
            
            // Update Likes Text
            
            User_Manager.instance.setLikesAmount(feed: feed, cell: cell)
        })
        
        
        
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
        
        let likes: Int = Int(likesAmount)!
        
        print(likes)
        
        if ( likeCurrentState ){
            
            // +1 Like , changeimage to full heart
            
            if let image = UIImage(named: "fullheart.png") {
                
                currentHeartButton.setImage(image, for: .normal)
                currentHeartButton.isEnabled = false
                User_Manager.instance.plusLikes(uid: uid, feedID: feedID, likes: likes)
                currentHeartButton.setTitle("\(likes+1) Likes",for: .normal)
                print("true")
            }
            
        } else {
            // -1 like, change image to empty heart
            if let image = UIImage(named: "icon-like.png") {
                currentHeartButton.setImage(image, for: .normal)
                currentHeartButton.isEnabled = false
                User_Manager.instance.minusLikes(uid: uid, feedID: feedID, likes: likes)
                currentHeartButton.setTitle("\(likes-1) Likes",for: .normal)
                print("false")
            }
        }
        currentHeartButton.isEnabled = true
    }
}
