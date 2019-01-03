//
//  MyFeedTableViewCell.swift
//  Instant
//
//  Copyright © 2018 All rights reserved.
//

import UIKit

class MyFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var textLabelC: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
