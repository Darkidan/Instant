//
//  ProfileViewController.swift
//  Instant
//
//  Copyright © 2018-2019 All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    var feedArray = [Feed]()
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
        User_Manager.instance.getProfileFeed {
            self.feedArray = User_Manager.instance.getFeedArray()
            self.tableView.reloadData()
        }
        
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
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
        
        cell.delegate = self
        cell.currentCellIndex = indexPath.row
        cell.ptext!.text = feedArray[indexPath.row].text
        cell.likesButton.setTitle("\(feedArray[indexPath.row].likes) Likes",for: .normal)
        
        let d = CustomViewController.setDate(dateTime: feedArray[indexPath.row].lastUpdate!)
        cell.date!.text = String(d)
        
        cell.pimage.image = UIImage(named: "wait_for_it")
        cell.pimage.tag = indexPath.row
        if (feedArray[indexPath.row].urlImage) != "" {
            User_Manager.instance.getImage(url: feedArray[indexPath.row].urlImage) { (image:UIImage?) in
                if (cell.pimage!.tag == indexPath.row){
                    if image != nil {
                        cell.pimage.image = image!
                        cell.pimage.clipsToBounds = true
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
            vc.beforeText = feedArray[self.selectedIndex!].text
            vc.feedID = feedArray[self.selectedIndex!].id
            vc.imageURL = feedArray[self.selectedIndex!].urlImage
        }
    }
}
