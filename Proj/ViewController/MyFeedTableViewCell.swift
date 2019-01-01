//
//  MyFeedTableViewCell.swift
//  Proj
//
//  Created by Darkidan on 30/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import UIKit

class MyFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var textLabelC: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    
    //var username:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  usernameLabel.text = username
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
