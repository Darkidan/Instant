//
//  MyFeedTableViewCell.swift
//  Instant
//
//  Copyright © 2018-2019 All rights reserved.
//

import UIKit

protocol FeedCellDelegate {
    func handleLike(uid: String,feedID: String,likeCurrentState: Bool,currentHeartButton: UIButton,likesAmount: String)
}

class MyFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var textLabelC: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var feedID: String?
    var likesAmount: String?
    let userid = UserDefaults.standard.string(forKey: "uid")
    var delegate: FeedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //🖤
    
    func likeState() -> Bool {
        if ( heartButton.currentImage == UIImage(named: "icon-like") ) {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func heartButtonClick(_ sender: Any) {
        delegate?.handleLike(uid: userid!, feedID: feedID!,likeCurrentState: likeState(),currentHeartButton: heartButton,likesAmount: likesAmount!)
    }
}
