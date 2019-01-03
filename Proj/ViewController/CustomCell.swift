//
//  CustomCell.swift
//  Proj
//
//  Created by admin on 01/01/2019.
//  Copyright © 2019 Darkidan. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol FriendCellDelegate {
    
    func handleFriend(name: String,
                      buttonText: String,
                      currentCell: CustomCell,
                      indexPath: IndexPath
                    )
    
}

class CustomCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var name: UILabel!
    var cellIndex: IndexPath?
    
    var delegate: FriendCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickButton(_ sender: UIButton) {
        
        // Get friend UID by username
        
        delegate?.handleFriend(name: self.name.text!,buttonText: self.addButton.titleLabel!.text!,currentCell: self,indexPath: cellIndex!)
        
        
    }
}
