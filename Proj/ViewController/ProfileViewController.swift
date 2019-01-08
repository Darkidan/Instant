//
//  ProfileViewController.swift
//  Instant
//
//  Copyright © 2018-2019 All rights reserved.
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
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        self.tableView.register(UINib(nibName: "profileCustomCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        self.tableView.rowHeight = 350
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // get all feeds by user id
        let ref = Database.database().reference()
        print("get feeds from user")
        // Get feeds from user id
       // print((User_Manager.instance.user?.feeds)?.count)
        ref.child("Users/\(User_Manager.instance.user?.id ?? "userid")/feed").observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if(DataSnapshot.childrenCount != 0){
                let arr = DataSnapshot.value as! [String]
                // Get all feeds by lastUpdate order
                // Select only those that belong to current logged user.
                ref.child("Feeds").queryOrdered(byChild: "lastUpdate").observeSingleEvent(of: .value, with: {snapshot in
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        if ( arr.contains(snap.key) ){
                            self.feedsDataSnapshotArray.append(snap)
                        }
                    }
                    self.feedsDataSnapshotArray.reverse()
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
       User_Manager.instance.getUser { (user) in
            self.user = user
            self.username.text = user.username
            self.email.text = user.email
        print("user URL: \(user.url)")
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
        return feedsDataSnapshotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
        
        cell.delegate = self
        cell.currentCellIndex = indexPath.row
        
        for item in feedsDataSnapshotArray[indexPath.row].children{
            let secondSnap = item as! DataSnapshot
            let key = secondSnap.key
            let val = secondSnap.value
            
            if ( key == "text") {
                cell.ptext!.text = val as? String
            }
            if ( key == "likes"){
                cell.likesButton.setTitle("\(val!) Likes",for: .normal)
            }
            
            if ( key == "lastUpdate" ){
                let d = CustomViewController.setDate(dateTime: val as! Double)
                cell.date!.text = String(d)
            }
            
            if ( key == "urlImage"){
                cell.pimage.image = UIImage(named: "wait_for_it")
                cell.pimage.tag = indexPath.row
                if (val as! String) != "" {
                    User_Manager.instance.getImage(url: val as! String) { (image:UIImage?) in
                        if (cell.pimage!.tag == indexPath.row){
                            if image != nil {
                                cell.pimage.image = image!
                                cell.pimage.clipsToBounds = true
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
}

extension ProfileViewController: ProfileCellDelegate{
    func handleEdit(cellIndex: Int) {
        self.selectedIndex = cellIndex
        performSegue(withIdentifier: "editFeed", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if ( segue.identifier == "editFeed" ){
            let vc: EditFeedViewController = segue.destination as! EditFeedViewController
            
            print(self.selectedIndex!)
            
            for item in feedsDataSnapshotArray[self.selectedIndex!].children{
                let secondSnap = item as! DataSnapshot
                let key = secondSnap.key
                let val = secondSnap.value
                
                if ( key == "text") {
                    vc.beforeText = val as? String
                }
                
                if ( key == "id" ){
                    vc.feedID = val as? String
                }
                
                if ( key == "urlImage"){
                    vc.imageURL = val as? String
                }
            }
        }
    }
}
