//
//  MyFeedTableViewController.swift
//  Proj
//
//  Created by Darkidan on 30/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import UIKit
import FirebaseDatabase
class MyFeedTableViewController: UITableViewController {
    
    var data = [Feed]()
    var myfeedListener:NSObjectProtocol?


    override func viewDidLoad() {
        super.viewDidLoad()
        User_Manager.instance.getUsername()

      //  self.tableView.rowHeight = 100
        
        myfeedListener = UserManagerNotification.myfeedListNotification.observe(){ (data:Any) in
            self.data = data as! [Feed]
            self.tableView.reloadData()
        }
        
        //User_Manager.instance.getAllFeeds()
        
        let ref = Database.database().reference()
        ref.child("Feeds").observeSingleEvent(of: .value) { (DataSnapshot) in
            let FeedData = DataSnapshot.value as? [String: Any]
            for feed in FeedData! {
               // print(feed)
            }
        }
        
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("Data Count: \(data.count)")
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyFeedTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "MyFeedCell", for: indexPath) as! MyFeedTableViewCell)
        
        let feed = data[indexPath.row]
        cell.usernameLabel.text = feed.username
        
        return cell
    }
}
