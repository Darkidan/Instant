//
//  EditFeedViewController.swift
//  Instant"
//
//  Created by admin on 05/01/2019.
//  Copyright © 2019 Darkidan. All rights reserved.
//

import UIKit

class EditFeedViewController: UIViewController {
    
    var feedID: String?
    var imageURL: String?
    var beforeText: String?
    
    override func viewDidLoad() {
        print("Text Passed: \(beforeText!) ImageURL: \(imageURL ?? "defaulturl") feedID: \(feedID ?? "defaultid")")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
