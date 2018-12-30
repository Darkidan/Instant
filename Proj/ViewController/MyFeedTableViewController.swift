//
//  MyFeedTableViewController.swift
//  Proj
//
//  Created by Darkidan on 30/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import UIKit

class MyFeedTableViewController: UITableViewController {
    
    var data = [Feed]()
    var myfeedListener:NSObjectProtocol?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 300
        
        myfeedListener = UserManagerNotification.myfeedListNotification.observe(){
            (data:Any) in
            self.data = data as! [Feed]
            self.tableView.reloadData()
        }
        
        User_Manager.instance.getAllFeeds()
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
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyFeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyFeedCell", for: indexPath) as! MyFeedTableViewCell
        
        let feed = data[indexPath.row]
        cell.usernameLabel.text = feed.username
        //cell.textFeedLabel.text = feed.text
        
        return cell
    }
}
