//
//  FriendsViewController.swift
//
//  Copyright © 2019 All rights reserved.
//

import UIKit
import FirebaseDatabase

class FriendsViewController: UIViewController,UITableViewDataSource{
    
    // Get friends by logged user id from firebase
    
    var Friends = [String]()
    var FriendsImg = [String]()
    var EveryUser = [String]()
    let userid = UserDefaults.standard.string(forKey: "uid")
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchFiltered = [String]()
    var searching = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "custom")
        
        // Get Friends List
        
        let ref = Database.database().reference()
        ref.child("Friends/\(userid!)").observeSingleEvent(of: .value){
            (DataSnapshot) in
            let friendsData = DataSnapshot.value as? [String:Any]
            if ( friendsData != nil){
                for friendUID in friendsData!{
                    ref.child("Users/\(friendUID.value)").observeSingleEvent(of: .value)
                    {
                        (DataSnapshot2) in
                        let userData = DataSnapshot2.value as? [String:Any]
                        if ( DataSnapshot2.childrenCount != 0 ){
                            self.Friends.append(userData!["username"] as! String)
                            self.FriendsImg.append(userData!["url"] as! String)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        // Get a list of every user to later filter search results
        
        ref.child("Users").observeSingleEvent(of: .value, with: { (DataSnapshot) in
            for child in DataSnapshot.children{
                let firstSnap = child as! DataSnapshot
                let k = firstSnap.key
                
                if ( k != self.userid ){// Dont take my user as a friend
                    for item in firstSnap.children {
                        let secondSnap = item as! DataSnapshot
                        let key = secondSnap.key
                        let val = secondSnap.value
                        if (key == "username"){
                            self.EveryUser.append((val as! String))
                        }
                    }
                }
                
            }
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( searching ){
            return self.searchFiltered.count
        } else {
            return self.Friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CustomCell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        
        cell.delegate = self
        cell.cellIndex = indexPath
        
        /** Assign User Profile Image
         let imgURL = self.FriendsImg[indexPath.row]
         let url = URL(string: imgURL)
         if ( url != nil ){
         let data = try? Data(contentsOf: (url!))
         
         if let imageData = data {
         cell.img.image = UIImage(data: imageData)
         }
         }**/
        
        if ( searching ){
            cell.name.text = self.searchFiltered[indexPath.row]
            cell.addButton.setTitle("+", for:.normal)
        } else {
            cell.name.text = self.Friends[indexPath.row]
            cell.addButton.setTitle("-", for:.normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            Friends.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    
    
}

extension FriendsViewController: FriendCellDelegate{
    
    func handleFriend(name: String,buttonText: String,currentCell: CustomCell,indexPath: IndexPath) {
        let ref = Database.database().reference()
        
        ref.child("Users").observeSingleEvent(of: .value, with: { (DataSnapshot) in
            for child in DataSnapshot.children{
                let firstSnap = child as! DataSnapshot
                let firstKey = firstSnap.key
                for item in firstSnap.children {
                    let secondSnap = item as! DataSnapshot
                    let key = secondSnap.key
                    let val = secondSnap.value
                    if (key == "username"){
                        if ( (val as! String) == name ){
                            let uid = firstKey
                            if ( buttonText == "+"){
                                // Add Friend to this user UID
                                ref.child("Friends/\(self.userid!)").child("Friend_\(uid)").setValue(uid)
                                ref.child("Friends/\(uid)").child("Friend_\(self.userid!)").setValue(self.userid!)
                                // change + to Added
                                currentCell.addButton.setTitle("V",for: .normal)
                                self.Friends.append(name)
                                
                            } else {
                                // Remove Friend
                                ref.child("Friends/\(self.userid!)").child("Friend_\(uid)").removeValue()
                                ref.child("Friends/\(uid)").child("Friend_\(self.userid!)").removeValue()
                                self.Friends.remove(at: indexPath.row)
                                self.EveryUser.append(name)
                                self.tableView.reloadData()
                            }
                            break;
                        }
                    }
                }
                
            }
        })
    }
    
}

extension FriendsViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if ( searchText.count == 0 ){ // Show Friends
            searchFiltered = Friends
            searching = false
        } else { // Show Search Results
            self.EveryUser = Array(Set(self.EveryUser).subtracting(self.Friends))
            searchFiltered = self.EveryUser.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
            searching = true
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}

