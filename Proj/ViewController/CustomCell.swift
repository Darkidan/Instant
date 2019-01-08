//
//  CustomCell.swift
//  Instant
//
//  Copyright © 2018-2019 All rights reserved.
//

import UIKit

protocol FriendCellDelegate {
    
    func handleFriend(name: String, buttonText: String, currentCell: CustomCell,indexPath: IndexPath)
}

class CustomCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var name: UILabel!
    var cellIndex: IndexPath?
    
    var delegate: FriendCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func clickButton(_ sender: UIButton) {
        // Get friend UID by username
        delegate?.handleFriend(name: self.name.text!,buttonText: self.addButton.titleLabel!.text!,currentCell: self,indexPath: cellIndex!)
    }
}
