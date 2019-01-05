//
//  ProfileViewController.swift
//  Instant
//
//  Copyright © 2018 All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    let userid = UserDefaults.standard.string(forKey: "uid")
    var feedsDataSnapshotArray = [DataSnapshot]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        self.tableView.register(UINib(nibName: "profileCustomCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        self.tableView.rowHeight = 370
        
        // get all feeds by user id
        
        let ref = Database.database().reference()
        
        ref.child("Feeds").observeSingleEvent(of: .value, with: { (DataSnapshot) in
            for child in DataSnapshot.children{
                let firstSnap = child as! DataSnapshot
                
                for item in firstSnap.children {
                    let secondSnap = item as! DataSnapshot
                    let key = secondSnap.key
                    let val = secondSnap.value
                    //print("Key: \(key) Value: \(val!)")
                    if (key == "uid" && (val as! String) == self.userid){ // My Post
                        self.feedsDataSnapshotArray.append(firstSnap)
                        //print("My UID: \(self.userid!) Feed uid: \(val!)")
                        //print(firstSnap)
                    }
                }
                
            }
            self.tableView.reloadData()
            //print("-----------------------------------------")
            //print(feedsDataSnapshotArray)
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        User_Manager.instance.getUser { (user) in
            self.user = user
            self.username.text = user.username
            self.email.text = user.email
            
            if user.url != "" {
                User_Manager.instance.getImageProfile(url: user.url) { (image:UIImage?) in
                    if image != nil {
                        self.imageAvatar.image = image!
                    }
                }
            }
            self.spinner.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageAvatar.contentMode = .scaleAspectFill
        self.imageAvatar.layer.cornerRadius = 50
        self.imageAvatar.clipsToBounds = true
    }
    
    @IBAction func logout(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "usersignedin"){
            User_Manager.instance.logoutSignIn(onSuccess: {
                let storyboard = UIStoryboard(name: "Sign", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.present(vc!, animated: true, completion: nil)
            }) { (error) in
                print(error?.localizedDescription as Any)
            }
        }
        else if UserDefaults.standard.bool(forKey: "usersignedup"){
            User_Manager.instance.logoutSignUp(onSuccess: {
                let storyboard = UIStoryboard(name: "Sign", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.present(vc!, animated: true, completion: nil)
            }) { (error) in
                print(error?.localizedDescription as Any)
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(feedsDataSnapshotArray.count)
        return feedsDataSnapshotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
        
        for item in feedsDataSnapshotArray[indexPath.row].children{
            let secondSnap = item as! DataSnapshot
            let key = secondSnap.key
            let val = secondSnap.value
            
            if ( key == "text") {
                cell.ptext!.text = val as! String
            }
            if ( key == "likes"){
                cell.likesButton.setTitle("\(val!) Likes",for: .normal)
            }
            
            if ( key == "lastUpdate" ){
                let d = CustomViewController.setDate(dateTime: val as! Double)
                cell.date!.text = String(d)
            }
            
            if ( key == "urlImage"){
                
            }
        }
        
        cell.pimage.image = UIImage(named: "wait_for_it")
        /*cell.pimage.tag = indexPath.row
         if feed.urlImage != "" {
         User_Manager.instance.getImage(url: feed.urlImage) { (image:UIImage?) in
         if (cell.feedImage!.tag == indexPath.row){
         if image != nil {
         cell.feedImage.image = image!
         cell.feedImage.clipsToBounds = true
         }
         }
         }
         }*/
        
        return cell
    }
    
    
    
}
