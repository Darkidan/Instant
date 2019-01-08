//
//  FriendsViewController.swift
//  Instant
//
//  Copyright © 2018-2019 All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController,UITableViewDataSource{
    
    var Friends = [String]()
    var FriendsImg = [String]()
    var EveryUser = [String]()
    var once: Bool = true
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchFiltered = [String]()
    var searching = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "custom")
        
        // Get Friends List
        User_Manager.instance.getFriendsList(tableView: self.tableView,onSuccess: {_ in
            self.Friends = User_Manager.instance.getFriendsArray()
            self.tableView.reloadData()
        })
        
        // Get a list of every user to later filter search results
        User_Manager.instance.getUserList { (list) in
            self.EveryUser = list
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching){
            return self.searchFiltered.count
        } else {
            return self.Friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        
        cell.delegate = self
        cell.cellIndex = indexPath
        
        if (searching){
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
        
        User_Manager.instance.handleFriendRequest(name: name, buttonText: buttonText, currentCell: currentCell, indexPath: indexPath) { (action) in
            if ( action == "+" ){
                self.Friends = User_Manager.instance.getFriendsArray()
                currentCell.addButton.setTitle("V",for: .normal)
                //self.tableView.reloadData()
            } else {
                self.Friends = User_Manager.instance.getFriendsArray()
                self.EveryUser = User_Manager.instance.getEveryUserArray()
                self.tableView.reloadData()
            }
        }
        
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
