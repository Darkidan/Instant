//
//  ProfileTableViewCell.swift
//  Proj
//
//  Created by admin on 05/01/2019.
//  Copyright © 2019 Darkidan. All rights reserved.
//

import UIKit

protocol ProfileCellDelegate {
    func handleEdit(cellIndex: Int)
}

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var pimage: UIImageView!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet var ptext: UILabel!
    @IBOutlet weak var date: UILabel!
    var currentCellIndex: Int?
    
    var delegate: ProfileCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editClicked(_ sender: Any) {
        delegate?.handleEdit(cellIndex: currentCellIndex!)
        
    }
    
}
