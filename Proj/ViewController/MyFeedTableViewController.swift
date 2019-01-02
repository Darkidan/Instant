//
//  MyFeedTableViewController.swift
//  Proj
//
//  Created by Darkidan on 30/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import UIKit
//import FirebaseDatabase
class MyFeedTableViewController: UITableViewController {
    
    var data = [Feed]()
    var myfeedListener:NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        User_Manager.instance.getUsername()

       self.tableView.rowHeight = 450
        
        myfeedListener = UserManagerNotification.myfeedListNotification.observe(){ (data1:Any) in
            self.data = data1 as! [Feed]
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
    
    func setDate(dateTime:Double)-> String{
        let date = NSDate(timeIntervalSince1970: (dateTime)/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date as Date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd/MM/yy, HH:mm"
        let finaldate = formatter.string(from: yourDate!)
        return finaldate
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (data.count)
        return data.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyFeedTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "MyFeedCell", for: indexPath) as! MyFeedTableViewCell)
        
        let feed = data[indexPath.row]
        cell.UsernameLabel.text = feed.username
        cell.textLabelC.text = feed.text
        if feed.lastUpdate != nil {
            cell.lastUpdate.text = setDate(dateTime: feed.lastUpdate!)
        }

        cell.feedImage.image = UIImage(named: "avatar")
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
